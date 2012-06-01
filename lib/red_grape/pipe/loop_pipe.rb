require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class LoopPipe < Pipe::Base
      def pass(obj, context)
        condition, label = *self.opts

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
        if context.eval :it => obj, &condition
          obj.pass_through anchor_pipe, context
        else
          context.loops = 1
          pass_next context, nil, obj
        end
      end
    end
  end
end
