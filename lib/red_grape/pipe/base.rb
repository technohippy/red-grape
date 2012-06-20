require 'red_grape/pipe/context'

module RedGrape
  module Pipe
    class Pipelines # TODO: Arrayのpass_throughが邪魔して使えないので・・・
      def initialize(pipes)
        @pipes = pipes
      end

      def take(context)
        @pipes.map {|p| p.take(context)}
      end
    end

    @@auto_take = false

    def self.auto_take
      @@auto_take
    end

    def self.set_auto_take(val=true)
      @@auto_take = val
    end

    class Base
      attr_accessor :opts, :prev, :next, :value, :it

      def initialize(prev, *opts, &block)
        @prev = prev
        @next = nil
        @opts = opts
        @block = block
      end

      def pipe_name
        self.class.name.split('::').last.sub(/Pipe$/, '')
      end

      def first_pipe
        pipe = self
        pipe = pipe.prev until pipe.first?
        pipe
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

      def take(context=Context.new)
        if first?
          val = @prev.pass_through self, context
          # TODO: should be refactored
          if context.aggregating?
            context.resume_from_aggregating
          elsif context.grouping?
            context.resume_from_grouping
          elsif context.gathering?
            context.resume_from_gathering
          elsif context.counting?
            context.resume_from_counting
          else
            val
          end
        else
          @prev.take
        end
      end
      alias [] take

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

      def pipe_eval(params={}, &block)
        params.each {|k, v| self.send "#{k}=", v}
        instance_eval(&block)
      end

      def to_s
        Pipe.auto_take ? take.to_s : super
      end

      def to_ary; nil end # TODO: i dont know why.

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
        #auto_take = name =~ /(.*)!$/ # TODO
        #name = $1
        class_name = "#{name.to_s.sub(/^./){$&.upcase}.gsub(/_(.)/){$1.upcase}}Pipe"
        args.unshift block if block # 引数の数は変わるので、blockは必ず1番目に追加しておく
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
