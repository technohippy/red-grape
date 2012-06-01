require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module As
      def as(*opts)
        AsPipe.new self, *opts
      end
    end

    class AsPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first.to_s
        case self.prev
        when Pipe::Base
          # TODO: why??
          context.mark! label
          obj
        when Vertex, Array
          context.mark! label, obj
          obj.pass_through self.next, context
        else
          raise 'not yet'
        end
      end
    end
  end
end

