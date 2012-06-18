require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class GatherPipe < Pipe::Base
      def pass(obj, context)
        context.gather obj, self.next
        obj
      end
    end
  end
end
