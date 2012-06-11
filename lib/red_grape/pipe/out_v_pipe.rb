require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module OutV
      def out_v(*opts)
        OutVPipe.new self, *opts
      end
      alias outV out_v
    end

    class OutVPipe < Pipe::Base
      def pass(obj, context)
        source = obj.source
        pass_next context, obj, source
      end
    end
  end
end
