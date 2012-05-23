require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module Fill
      def fill(*opts)
        FillPipe.new self, *opts
      end
    end

    class FillPipe < Pipe::Base
      def pass(obj, context)
        container = self.opts.first
        container << obj
        obj
      end
    end
  end
end
