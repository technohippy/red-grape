require 'red_grape/property_description'

module RedGrape
  class Element
    def initialize(graph, opts={})
      @graph = graph
      @property = {}
      if opts[:property_description]
        @property_description = opts[:property_description]
        (opts[:property] || {}).each do |k, v|
          self[k] = v
        end
      else
        @property_description = {}
        opts.each do |k, v|
          self[k] = v
        end
      end
      @property_description.each do |k ,v|
        if v.is_a? Array
          v = PropertyDescription.new(*v)
        elsif v.is_a? Hash
          v = PropertyDescription.new v[:name], v[:type], v[:default]
        end
        @property_description[k] = v
        set_property k, v.default if v.has_default?
      end
    end
    
    # set property value with type checking
    def set_property(kid, v)
      # TODO: should be refactored
      desc = @property_description[kid]
      if desc.accessible? v
        self[desc.name] = v
      elsif desc.convertable? v
        self[desc.name] = desc.convert v
      else
        raise ArgumentError.new "#{kid} should be #{desc.type}."
      end
    end

    # set property value without type checking
    def []=(k, v)
      @property[k.to_s] = v
    end

    def [](k)
      @property[k.to_s]
    end

    def pass_through(pipe, context)
      pipe.pass self, context
    end

    def ==(obj)
      self.class == obj.class && self.id == obj.id
    end

    def method_missing(name, *args, &block)
      self[name.to_s] or raise NoMethodError.new(name.to_s)
    end
  end
end
