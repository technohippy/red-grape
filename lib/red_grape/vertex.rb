require 'red_grape/element'

module RedGrape
  class Vertex < Element
    include RedGrape::Pipe::Both
    include RedGrape::Pipe::Out
    include RedGrape::Pipe::OutE
    include RedGrape::Pipe::In
    include RedGrape::Pipe::InE
    include RedGrape::Pipe::SideEffect
    include RedGrape::Pipe::As
    include RedGrape::Pipe::Fill

    attr_reader :id, :out_edges, :in_edges

    def initialize(graph, id, opts={})
      super graph, opts
      @id = id.to_s
      @out_edges = []
      @in_edges = []
    end

    # Returns edges
    # _direction_ :: :out or :in
    # _labels_ :: labels
    def edges(direction, *labels)
      edges = directed_value direction, @out_edges, @in_edges
      if labels.empty?
        edges
      else
        edges.select {|e| labels.include? e.label}
      end
    end

    def vertices(direction, *labels)
      edges = edges direction, *labels
      directed_value direction, proc{edges.map &:target}, proc{edges.map &:source}
    end

    def add_out_edge(edge)
      @out_edges << edge
    end

    def add_in_edge(edge)
      @in_edges << edge
    end

    def to_s
      "v[#{@id}]"
    end

    def to_h
      {
        version: RedGrape::VERSION,
        results: {
          _type: '_vertex',
          _id: @id
        }.merge(@property)
      }
    end
  end
end
