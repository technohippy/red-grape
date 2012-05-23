require 'red_grape/pipe/context'

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

      def take
        if first?
          context = Context.new
          val = @prev.pass_through self, context
          if context.aggregating?
            context.resume_from_aggregating
          elsif context.grouping?
            context.resume_from_grouping
          else
            val
          end
        else
          @prev.take
        end
      end

      def to_s
        #TODO: flag
        take.to_s
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

      def size
        len = 0
        pipe = self
        while pipe.is_a?(Pipe::Base) and pipe.prev
          len += 1 
          pipe = pipe.prev
        end
        len
      end

      # note: both prev and next are not copied.
      def dup
        self.class.new nil, @opts, &@block
      end

      def method_missing(name, *args, &block)
        class_name = "#{name.to_s.sub(/^./){$&.upcase}.gsub(/_(.)/){$1.upcase}}Pipe"
        args.unshift block if block
        pipe_class =
          if Pipe.const_defined? class_name
            eval "RedGrape::Pipe::#{class_name}"
          else
            args.unshift name
            PropertyPipe
          end
        @next = pipe_class.new self, *args
      end
    end
  end
end
