require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module E
      def e(*opts)
        EPipe.new self, *opts
      end
      alias E e
    end

    class EPipe < Pipe::Base
      def pass(obj, context)
        edges = obj.edge(*self.opts)
        pass_next context, obj, edges 
      end
    end
  end
end

