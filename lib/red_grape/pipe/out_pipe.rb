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
        group =
          if self.opts.empty? or self.opts.first.empty? # TODO なぜかlabelに[]が入ってる
            VertexGroup.new obj.out_edges.map(&:target)
          else
            label = self.opts.first
            VertexGroup.new obj.out_edges.find_all{|e| e.label == label}.map(&:target)
          end
        pass_next context, obj, group
      end
    end
  end
end
