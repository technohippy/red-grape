require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class SelectPipe < Pipe::Base
      def pass(obj, context)
        context.marks
      end
    end
  end
end
