require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class ExceptPipe < Pipe::Base
      def pass(obj, context)
        if context.aggregated_items(self.opts.first).include? obj
          nil
        else
          obj
        end
      end
    end
  end
end
