require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module V
      def v(*opts)
        VPipe.new self, *opts
      end
      alias V v
    end

    class VPipe < Pipe::Base
      def pass(obj, context)
        vertices = obj.vertex(*self.opts)
        pass_next context, obj, vertices 
      end
    end
  end
end
