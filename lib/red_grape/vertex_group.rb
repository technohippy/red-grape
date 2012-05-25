require 'red_grape/vertex'
require 'forwardable'

module RedGrape
  class VertexGroup < Vertex
    extend Forwardable
    def_delegators :@group, :size, :map, :sort, :empty?

    attr_reader :group

    def initialize(group=[])
      @group = group
    end

    def pass_through(pipe, context) 
      @group.map! do |v|
        pipe.pass v, context
      end
      normalize
      @group.all? {|e| e.is_a? self.class} ? self : @group
    end

    def normalize
      @group.reject! do |v|
        v.nil? or (v.respond_to?(:empty?) and v.empty?) # TODO
      end
      @group.map! do |v|
        v.is_a?(self.class) ? v.group : v
      end
      #@group.flatten!
      flatten_group!
      self
    end

    def flatten_group
      ret = []
      @group.each do |v|
        case v
        when Array
          ret += v.flatten
        when self.class
          ret += v.group.flatten_group
        else
          ret << v
        end
      end
      ret
    end

    def flatten_group!
      @group = flatten_group
    end

    def to_a
      @group.dup.map{|e| e.is_a?(self.class) ? e.to_a : e}
    end

    def to_s
      "[#{@group.map(&:to_s).join ', '}]"
    end
  end
end
