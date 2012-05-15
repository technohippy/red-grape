require 'red_grape/vertex'

module RedGrape
  class VertexGroup < Vertex
    def initialize(group=[])
      @group = group
    end

    def _group
      @group
    end

    def pass_through(pipe, context) 
      @group.map! do |v|
        pipe.pass v, context
      end
      #end.compact!
      @group.reject! do |v|
        v.nil? or (v.respond_to?(:empty?) and v.empty?) # TODO
      end
      @group.map! do |v|
        v.is_a?(RedGrape::VertexGroup) ? v._group : v
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
        when VertexGroup
          ret += v._group.flatten_group
        else
          ret << v
        end
      end
      ret
    end

    def flatten_group!
      @group = flatten_group
    end

    def size
      @group.size
    end

    def empty?
      @group.empty?
    end

    def to_s
      "[#{@group.map(&:to_s).join ', '}]"
    end
  end
end
