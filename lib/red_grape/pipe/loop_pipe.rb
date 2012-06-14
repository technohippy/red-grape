require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class LoopPipe < Pipe::Base
      LoopContext = Struct.new :loops, :path, :object

      def pass(obj, context)
        if self.opts.first.is_a? Proc
          loop_condition, label = *self.opts
        else
          label, loop_condition, emit_condition = *self.opts
        end

        anchor_pipe = self;
        case label
        when Integer
          label.times {anchor_pipe = anchor_pipe.prev}
        when String, Symbol
          begin
            anchor_pipe = anchor_pipe.prev
          end until anchor_pipe.is_a?(AsPipe) && anchor_pipe.opts.first == label
        else
          raise 'label should be an integer or a string.'
        end
        context.loops += 1
        it = LoopContext.new context.loops, context.history, obj
        if context.eval :it => it, &loop_condition
          obj.pass_through anchor_pipe, context
        else
          context.loops = 1
          if emit_condition && !context.eval(:it => it, &emit_condition)
            nil
          else
            pass_next context, nil, obj
          end
        end
      end
    end
  end
end
