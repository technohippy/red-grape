require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class LoopPipe < Pipe::Base
      def pass(obj, context)
        condition, label = *self.opts

        anchor_pipe = self;
        label.times {anchor_pipe = anchor_pipe.prev}
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
