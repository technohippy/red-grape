require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class AsPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first.to_s
        context.mark! label
        obj
      end
    end
  end
end

