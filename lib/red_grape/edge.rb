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

    def to_s
      "e[#{@id}][#{@source.id}-#{@label}->#{@target.id}]"
    end
  end
end
