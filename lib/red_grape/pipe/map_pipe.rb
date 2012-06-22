require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class MapPipe < Pipe::Base
      def pass(obj, context)
        obj.property
      end
    end
  end
end

