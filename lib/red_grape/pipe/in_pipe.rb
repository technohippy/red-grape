require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class InPipe < Pipe::Base
      def pipe_name
        @opts.empty? ? super : "#{super}(#{@opts.first})"
      end

      def pass(obj, context)
        case obj
        when RedGrape::Vertex
          group =
            if self.opts.empty?
              VertexGroup.new obj._in_edges.map(&:source)
            else
              label = self.opts.first
              VertexGroup.new obj._in_edges.find_all{|e| e.label == label}.map(&:source)
            end
          if self.last?
            group
          else
            context.push_history obj do |ctx|
              group.pass_through self.next, ctx
            end
          end
        end
      end
    end
  end
end
