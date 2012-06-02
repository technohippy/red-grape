module RedGrape
  class PropertyDescription
    attr_reader :name, :type, :default

    def initialize(name, type, default=nil)
      @name = name
      @type = type
      @default = default
    end

    def accessible?(val)
      case type
      when 'int', 'integer'
        val.is_a? Integer
      when 'float'
        val.is_a? Numeric
      else
        true
      end
    end

    def convertable?(val)
      case type
      when 'int', 'integer'
        val =~ /^\d+$/
      when 'float'
        val =~ /^\d+(\.\d+)?$/
      else
        true
      end
    end

    def convert(val)
      case type
      when 'int', 'integer'
        val.to_i
      when 'float'
        val.to_f
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

