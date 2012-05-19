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
        when Vertex
          if self.last?
            context.mark! label
            obj
          else
            context.push_history obj do |ctx|
              context.mark! label
              obj.pass_through self.next, ctx
            end
          end
        else
          raise 'not yet'
        end
      end
    end
  end
end

