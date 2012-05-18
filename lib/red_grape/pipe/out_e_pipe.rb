require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module OutE
      def out_e(*opts)
        OutEPipe.new self, *opts
      end
      alias outE out_e
    end

    class OutEPipe < Pipe::Base
      def pass(obj, context)
puts :">>>>>out_e"
      end
    end
  end
end
