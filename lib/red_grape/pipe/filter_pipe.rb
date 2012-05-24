require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class FilterPipe < Pipe::Base
      def pass(obj, context)
        filter = self.opts.first
        if context.eval :it => obj, &filter
          pass_next context, obj
        else
          nil
        end
      end
    end
  end
end
