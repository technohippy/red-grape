require 'red_grape/edge'

#TODO delegate to array
module RedGrape
  class EdgeGroup < Edge
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
      @group.reject! do |v|
        v.nil? or (v.respond_to?(:empty?) and v.empty?) # TODO
      end
      @group.map! do |v|
        v.is_a?(self.class) ? v._group : v
      end
      #@group.flatten!
      flatten_group!
      @group.uniq!
      @group.all? {|e| e.is_a? self.class} ? self : @group
    end

    def flatten_group
      ret = []
      @group.each do |v|
        case v
        when Array
          ret += v.flatten
        when self.class
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

    def map(&block)
      @group.map(&block)
    end

    def sort(&block)
      @group.sort
    end

    def empty?
      @group.empty?
    end

    def to_a
      @group.dup.map{|e| e.is_a?(self.class) ? e.to_a : e}
    end

    def to_s
      "[#{@group.map(&:to_s).join ', '}]"
    end
  end
end
