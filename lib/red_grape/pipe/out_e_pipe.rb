require 'red_grape/pipe/base'
require 'red_grape/edge_group'

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
        edges = if label
            EdgeGroup.new obj.out_edges.dup.find_all{|e| e.label == label}
          else
            EdgeGroup.new obj.out_edges.dup
          end
        pass_next context, obj, edges
      end
    end
  end
end
