require 'red_grape/property_description'

module RedGrape
  class PropertiedObject
    def initialize(graph, opts={})
      @graph = graph
      @property = {}
      @property_description = opts[:property_description] || {}
      @property_description.each do |k ,v|
        if v.is_a? Array
          v = PropertyDescription.new *v
        elsif v.is_a? Hash
          v = PropertyDescription.new v[:name], v[:type], v[:default]
        end
        @property_description[k] = v
        set_property k, v.default if v.has_default?
      end
    end
    
    def set_property(kid, v)
      desc = @property_description[kid]
      if desc.accessible? v
        self[desc.name] = desc.convert(v)
      else
        raise ArgumentError.new "#{kid} should be #{desc.type}."
      end
    end

    def []=(k, v)
      # TODO: type check?
      @property[k.to_s] = v
    end

    def [](k)
      @property[k.to_s]
    end
  end
end
