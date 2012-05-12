require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module SideEffect
      def side_effect(&block)
        SideEffectPipe.new self, [block]
      end
    end

    class SideEffectPipe < Pipe::Base
      def pass(obj, history)
        side_effect = self.opts.first
        obj.instance_eval &side_effect
      end
    end
  end
end
