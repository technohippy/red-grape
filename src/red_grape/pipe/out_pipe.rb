require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module Out
      def out(*opts)
        OutPipe.new self, *opts
      end
    end

    class OutPipe < Pipe::Base
      def pipe_name
        @opts.empty? ? super : "#{super}(#{@opts.first})"
      end

      def pass(obj, history)
        case obj
        when RedGrape::Vertex
          group =
            if self.opts.empty?
              VertexGroup.new obj._out_edges.map(&:target)
            else
              label = self.opts.first
              VertexGroup.new obj._out_edges.find_all{|e| e.label == label}.map(&:target)
            end
          if self.last?
            group
          else
            group.pass_through self.next, :history => history + [obj]
          end
        end
      end
    end
  end
end
