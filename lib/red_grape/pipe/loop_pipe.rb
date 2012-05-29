require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class LoopPipe < Pipe::Base
      def pass(obj, context) # TODO: 無理やりすぎる実装・・・
        condition = self.opts.first
        label = self.opts[1]

        looped_pipe = self.prev.copy(label - 1)
        (label - 1).times {looped_pipe = looped_pipe.prev}

        context.loops += 1
        while context.eval :it => obj, &condition
          obj = obj.pass_through looped_pipe, context
          context.loops += 1
        end
        context.loops = 1
        pass_next context, obj
      end
    end
  end
end
