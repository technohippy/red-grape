module RedGrape
  class PropertyDescription
    attr_reader :name, :type, :default

    def initialize(name, type, default=nil)
      @name = name
      @type = type
      @default = default
    end

    def accessible?(v)
      # TODO
      true
    end

    def convert(val)
      case type
      when 'int'
        val.to_i
      else
        val
      end
    end

    def has_default?
      not @default.nil?
    end

    def to_s
      "{#{@name}:#{@type}:#{@default}}"
    end
  end
end

