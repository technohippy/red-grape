require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class BackPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first
        case label
        when Integer
          context.history[-label]
        else
          context.history.mark label
        end
      end
    end
  end
end
