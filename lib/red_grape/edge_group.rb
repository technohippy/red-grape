require 'red_grape/edge'

module RedGrape
  class EdgeGroup < Edge
    extend Forwardable
    def_delegators :@group, :size, :map, :sort, :empty?

    attr_reader :group

    def initialize(group=[])
      unless group.all?{|e| e.instance_of? Edge}
        raise ArgumentError.new 'All items should be Edge objects.' 
      end
      @group = group
    end

    def pass_through(pipe, context) 
      @group.map! do |v|
        pipe.pass v, context
      end
      @group.reject! do |v|
        v.nil? or (v.respond_to?(:empty?) and v.empty?) # TODO
      end
      @group.map! do |v|
        v.instance_of?(self.class) ? v.group : v
      end
      #@group.flatten!
      flatten_group!
      @group.uniq!
      #@group.all? {|e| e.instance_of? Edge} ? self : @group
      if @group.all?{|e| e.instance_of? Edge} # TODO
        self
      elsif @group.all?{|e| e.instance_of? Vertex}
        VertexGroup.new @group
      else
        @group
      end
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
      @group.dup.map{|e| e.instance_of?(self.class) ? e.to_a : e}
    end

    def to_s
      "[#{@group.map(&:to_s).join ', '}]"
    end
  end
end
