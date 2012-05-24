require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class CapPipe < Pipe::Base
      def pass(obj, context)
        ret = {}
        context.grouping_items.each do |e|
          ret[e.first] ||= 0
          ret[e.first] += 1
        end
        ret
      end
    end
  end
end
