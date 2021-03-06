require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class TransformPipe < Pipe::Base
      def pass(obj, context)
        transformer = self.opts.first
        val = context.eval :it => obj, &transformer
        pass_next context, val
      end
    end
  end
end
