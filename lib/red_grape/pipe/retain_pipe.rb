require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class RetainPipe < Pipe::Base
      def pass(obj, context)
        if context.aggregated_items(self.opts.first).include? obj
          obj
        else
          nil
        end
      end
    end
  end
end

