require 'red_grape/element'

module RedGrape
  class Vertex < Element
    include RedGrape::Pipe::Out
    include RedGrape::Pipe::OutE
    include RedGrape::Pipe::In
    include RedGrape::Pipe::SideEffect
    include RedGrape::Pipe::As
    include RedGrape::Pipe::Fill

    attr_reader :id, :out_edges, :in_edges

    def initialize(graph, id, opts={})
      super graph, opts
      @id = id
      @out_edges = []
      @in_edges = []
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
  end
end
