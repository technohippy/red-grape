require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module InE
      def in_e(*opts)
        InEPipe.new self, *opts
      end
      alias inE in_e
    end

    class InEPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first
        label = nil if label.is_a?(Array) && label.empty? # TODO
        edges = if label
            obj.in_edges.dup.find_all{|e| e.label == label}
          else
            obj.in_edges.dup
          end
        pass_next context, obj, edges
      end
    end
  end
end

