require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class CapPipe < Pipe::Base
      def pass(obj, context)
        ret = {}
        context.grouping_items.each do |k, v|
          v = v.map &:first
          ret[k] = self.pipe_eval(it:v, &self.prev.reduce_function)
        end
        ret
      end
    end
  end
end
