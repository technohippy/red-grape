module RedGrape
  class PathGroup
    def initialize(ary)
      @paths = ary.dup
    end

    def to_s
      @paths.to_s
    end
  end
end