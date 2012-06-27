require 'red_grape'

module RedGrape
  class GraphStore
    def initialize
      @graphs = {}
    end

    def graph_names
      @graphs.keys.sort
    end

    def graph(key)
      @graphs[key.to_s.to_sym]
    end
    alias [] graph

    def put_graph(key, graph)
      graph.name = key.to_s.to_sym
      self << graph
    end
    alias []= put_graph

    def <<(graph)
      raise ArgumentError.new('The given graph does not have its name.') unless graph.name
      @graphs[graph.name.to_sym] = graph
    end
  end
end
