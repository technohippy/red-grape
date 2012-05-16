module RedGrape
  class PropertiedObject
    def initialize(graph, opts={})
      @graph = graph
      @property = {}
      @property_description = opts[:property_description] || {}
      @property_description.each do |k ,v|
        set_property k, v.default if v.has_default?
      end
    end
    
    def set_property(kid, v)
      desc = @property_description[kid]
      self[desc.name] = desc.convert(v) if desc.accessible? v
    end

    def []=(k, v)
      @property[k.to_s] = v
    end

    def [](k)
      @property[k.to_s]
    end
  end
end
