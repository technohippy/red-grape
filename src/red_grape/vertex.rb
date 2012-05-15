require 'red_grape/propertied_object'

module RedGrape
  class Vertex < PropertiedObject
    include RedGrape::Pipe::Out
    include RedGrape::Pipe::SideEffect

    def initialize(graph, id, opts={})
      super graph, opts
      @id = id
      @out_edges = []
      @in_edges = []
    end

    def _id
      @id
    end

    def _in_edges
      @in_edges
    end

    def _out_edges
      @out_edges
    end

    def pass_through(pipe, context)
      pipe.pass self, context
    end

    def add_out_edge(edge)
      @out_edges << edge
    end

    def add_in_edge(edge)
      @in_edges << edge
    end

    def to_s
      "v[#{_id}]"
      #"v[id(#{_id}):#{@property}]"
    end

    def method_missing(name, *args, &block)
      self[name.to_s] or raise NoMethodError.new(name)
    end
  end
end
