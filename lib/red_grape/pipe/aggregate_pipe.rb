require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class AggregatePipe < Pipe::Base
      def pass(obj, context)
        key = self.opts.first
        context.aggregate key, obj, self.next
        obj
      end
    end
  end
end
