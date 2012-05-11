module RedGrape
  module Pipe
    class Base
      attr_accessor :opts, :prev, :next, :value

      def initialize(prev, *opts, &block)
        @prev = prev
        @next = nil
        @opts = opts
        @block = block
      end

      def pipe_name
        self.class.name.split('::').last
      end

      def first?
        not @prev.kind_of? RedGrape::Pipe::Base
      end

      def last?
        @next.nil?
      end

      def done?
        not @value.nil?
      end

      def invoke
        if first?
          @prev.pass_through self, :history => []
        elsif @prev.done? and last?
          @value
        else
          @prev.invoke
        end
      end

      def to_s
        #TODO: flag
        invoke.to_s
      end

      def to_a
        pipe = self
        ret = [pipe.pipe_name]
        until pipe.first?
          pipe = pipe.prev
          ret.unshift pipe.pipe_name
        end
        ret
      end

      def method_missing(name, *args, &block)
        class_name = "#{name.capitalize}Pipe"
        args.unshift block if block
        pipe_class =
          if RedGrape::Pipe.const_defined? class_name
            eval "RedGrape::Pipe::#{class_name}"
          else
            args.unshift name
            RedGrape::Pipe::PropertyPipe
          end
        @next = pipe_class.new self, *args
      end
    end
  end
end
