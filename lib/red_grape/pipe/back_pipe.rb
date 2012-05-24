require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class BackPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first
        obj = case label
          when Integer
            context.history[-label]
          else
            context.mark label
          end
        pass_next context, obj
      end
    end
  end
end
