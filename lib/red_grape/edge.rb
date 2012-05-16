require 'red_grape/propertied_object'

module RedGrape
  class Edge < PropertiedObject
    attr_reader :source, :target, :label

    def initialize(graph, id, source, target, label, opts={})
      super graph, opts
      @id = id
      @source = graph.vertex source
      @target = graph.vertex target
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
      #"e[id(#{_id}):v[#{@source._id}]-v[#{@target._id}]:#{@property}]"
      "e[#{_id}:v[#{@source._id}]-v[#{@target._id}]]"
    end
  end

  class EdgeGroup < Edge
  end
end
