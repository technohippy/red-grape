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
      @id = id.to_s
      @out_edges = []
      @in_edges = []
    end

    # Returns edges
    # _direction_ :: :out or :in
    # _labels_ :: labels
    def edges(direction, *labels)
      edges = case direction
        when :out, 'out'
          @out_edges
        when :in, 'in'
          @in_edges
        else
          raise ArgumentError.new(':out or :in')
        end
      if labels.empty?
        edges
      else
        edges.select {|e| labels.include? e.label}
      end
    end

    def vertices(direction, *labels)
      edges = edges direction, *labels
      case direction
      when :out, 'out'
        edges.map &:target
      when :in, 'in'
        edges.map &:source
      end
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
