require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module InV
      def in_v(*opts)
        InVPipe.new self, *opts
      end
      alias inV in_v
    end

    class InVPipe < Pipe::Base
      def pass(obj, context)
        target = obj.target
        pass_next context, obj, target
      end
    end
  end
end
