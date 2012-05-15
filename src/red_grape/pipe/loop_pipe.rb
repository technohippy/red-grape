require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class LoopPipe < Pipe::Base
      def pass(obj, context) # TODO: 無理やり・・・
        condition = self.opts.first
        label = self.opts[1]

        looped_pipe = self.prev.dup
        looped_pipe.prev = self.prev.prev
        (label - 1).times do
          prev = looped_pipe.prev.dup
          prev.next = looped_pipe
          looped_pipe = prev
        end

        context.loops += 1
        while context.eval :it => obj, &condition
          pipe = looped_pipe
          while pipe
            obj = obj.pass_through pipe, context
            pipe = pipe.next
          end
          context.loops += 1
        end
        context.loops = 1
        obj
      end
    end
  end
end
