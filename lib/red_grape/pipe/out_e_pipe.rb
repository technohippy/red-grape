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
            EdgeGroup.new obj._out_edges.find_all{|e| e.label == label}
          else
            EdgeGroup.new obj._out_edges
          end

        if self.last?
          edges
        else
          context.push_history obj do |ctx|
            edges.pass_through self.next, ctx
          end
        end
      end
    end
  end
end
