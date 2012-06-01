require 'forwardable'

module RedGrape
  class PathGroup
    extend Forwardable
    def_delegators :@paths, :size, :to_s, :[], :first, :last

    def initialize(ary)
      @paths = ary.dup
    end
  end
end
