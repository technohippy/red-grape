require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class CountPipe < Pipe::Base
      def pass(obj, context)
        context.count obj, self.next
        obj
      end
    end

    SizePipe = CountPipe
  end
end
