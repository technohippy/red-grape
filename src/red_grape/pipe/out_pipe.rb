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

      def pass(obj, context)
        case obj
        when RedGrape::Vertex
          group =
            if self.opts.empty? or self.opts.first.empty? # TODO なぜかlabelに[]が入ってる
              VertexGroup.new obj._out_edges.map(&:target)
            else
              label = self.opts.first
              VertexGroup.new obj._out_edges.find_all{|e| e.label == label}.map(&:target)
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
