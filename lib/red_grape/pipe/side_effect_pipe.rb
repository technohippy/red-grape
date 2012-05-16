require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module SideEffect
      def side_effect(&block)
        SideEffectPipe.new self, block
      end
    end

    class SideEffectPipe < Pipe::Base
      def pass(obj, context)
        side_effect = self.opts.first
        context.eval :it => obj, &side_effect
        if self.last?
          obj
        else
          obj.pass_through self.next, context
        end
      end
    end
  end
end
