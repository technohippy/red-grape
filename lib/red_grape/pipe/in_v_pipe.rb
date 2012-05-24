require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class InVPipe < Pipe::Base
      def pass(obj, context)
        target = obj.target
        pass_next context, obj, target
      end
    end
  end
end
