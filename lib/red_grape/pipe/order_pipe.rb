require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class OrderPipe < Pipe::Base
      def pass(obj, context)
        context.order obj, self.next
        obj
      end
    end
  end
end
