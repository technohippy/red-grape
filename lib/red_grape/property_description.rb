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
      else
        true
      end
    end

    def convertable?(val)
      case type
      when 'int', 'integer'
        val =~ /^\d+$/
      else
        true
      end
    end

    def convert(val)
      case type
      when 'int', 'integer'
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

