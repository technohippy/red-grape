require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module Both
      def both(*opts)
        BothPipe.new self, *opts
      end
    end

    class BothPipe < Pipe::Base
      def pipe_name
        @opts.empty? ? super : "#{super}(#{@opts.first})"
      end

      def pass(obj, context)
        group =
          if self.opts.empty? or self.opts.first.empty? # TODO なぜかlabelに[]が入ってる
            (obj.out_edges.map(&:target) + obj.in_edges.map(&:source)).uniq
          else
            label = self.opts.first
            out_edges = obj.out_edges.find_all{|e| e.label == label}.map(&:target)
            in_edges = obj.in_edges.find_all{|e| e.label == label}.map(&:source)
            (out_edges + in_edges).uniq
          end
        pass_next context, obj, group
      end
    end
  end
end
