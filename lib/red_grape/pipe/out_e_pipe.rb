require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module OutE
      def out_e(*opts)
        OutEPipe.new self, *opts
      end
      alias outE out_e
    end

    class OutEPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first
        label = nil if label.is_a?(Array) && label.empty? # TODO
        edges = if label
            obj.out_edges.dup.find_all{|e| e.label == label}
          else
            obj.out_edges.dup
          end
        pass_next context, obj, edges
      end
    end
  end
end
