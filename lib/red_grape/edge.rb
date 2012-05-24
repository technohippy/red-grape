require 'red_grape/graph_item'

module RedGrape
  class Edge < GraphItem
    attr_reader :source, :target, :label

    def initialize(graph, id, source, target, label, opts={})
      super graph, opts
      @id = id
      @source = source.is_a?(Vertex) ? source : graph.vertex(source)
      @target = target.is_a?(Vertex) ? target : graph.vertex(target)
      @source.add_out_edge self
      @target.add_in_edge self
      @label = label
    end

    def _id
      @id
    end

    def _source
      @source
    end

    def _target
      @target
    end

    def to_s
      "e[#{_id}][#{@source._id}-#{@label}->#{@target._id}]"
    end
  end
end
