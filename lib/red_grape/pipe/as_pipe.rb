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
        context.mark! label, obj
        obj.pass_through self.next, context
      end
    end
  end
end
