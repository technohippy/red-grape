require 'red_grape/pipe/context'

module RedGrape
  module Pipe
    @@auto_take = false

    def self.auto_take
      @@auto_take
    end

    def self.set_auto_take(val=true)
      @@auto_take = val
    end

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

      def pass_next(context, pushed_obj, next_obj=nil, &block)
        next_obj ||= pushed_obj
        if self.last?
          block.call if block
          next_obj
        elsif pushed_obj.nil?
          block.call if block
          next_obj.pass_through self.next, context
        else
          context.push_history pushed_obj do |ctx|
            block.call if block
            next_obj.pass_through self.next, ctx
          end
        end
      end

      def to_s
        Pipe.auto_take ? take.to_s : super
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

      def copy(depth=nil)
        obj = self.class.new nil, @opts, &@block
        if depth.nil?
          obj.prev = self.prev.copy
          obj.prev.next = obj
        elsif 0 < depth
          obj.prev = self.prev.copy(depth - 1)
          obj.prev.next = obj
        end
        obj
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
