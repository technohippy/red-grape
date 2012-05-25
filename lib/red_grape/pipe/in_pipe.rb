require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module In
      def in(*opts)
        InPipe.new self, *opts
      end
    end

    class InPipe < Pipe::Base
      def pipe_name
        @opts.empty? ? super : "#{super}(#{@opts.first})"
      end

      def pass(obj, context)
        group =
          if self.opts.empty?
            VertexGroup.new obj.in_edges.map(&:source)
          else
            label = self.opts.first
            VertexGroup.new obj.in_edges.find_all{|e| e.label == label}.map(&:source)
          end
        pass_next context, obj, group
      end
    end
  end
end
