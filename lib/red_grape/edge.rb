require 'red_grape/element'

module RedGrape
  class Edge < Element
    attr_reader :id, :source, :target, :label

    def initialize(graph, id, source, target, label, opts={})
      super graph, opts
      @id = id
      @source = source.is_a?(Vertex) ? source : graph.vertex(source)
      @target = target.is_a?(Vertex) ? target : graph.vertex(target)
      @source.add_out_edge self
      @target.add_in_edge self
      @label = label
    end

    def vertex(direction)
      directed_value direction, @target, @source
    end

    def connected?(v)
      id = v.is_a?(Vertex) ? v.id : v
      @source.id == id.to_s || @target.id == id.to_s
    end

    def to_s
      "e[#{@id}][#{@source.id}-#{@label}->#{@target.id}]"
    end
  end
end
