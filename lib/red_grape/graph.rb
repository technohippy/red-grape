require 'red_grape/vertex'
require 'red_grape/edge'
require 'red_grape/property_description'
require 'red_grape/serializer/graphml_serializer'

module RedGrape
  class Graph
    include RedGrape::Pipe::V
    include RedGrape::Pipe::E

    class << self
      def load(filename)
        self.new.load filename
      end

      # Returns the default graph which has 6 vertices and 6 edges.
      def create_tinker_graph
        self.new do |g|
          v1 = g.add_vertex 1, name:'marko', age:29
          v2 = g.add_vertex 2, name:'vadas', age:27
          v3 = g.add_vertex 3, name:'lop', lang:'java'
          v4 = g.add_vertex 4, name:'josh', age:32
          v5 = g.add_vertex 5, name:'ripple', lang:'java'
          v6 = g.add_vertex 6, name:'peter', age:35
          g.add_edge 7, v1, v2, 'knows', weight:0.5
          g.add_edge 8, v1, v4, 'knows', weight:1.0
          g.add_edge 9, v1, v3, 'created', weight:0.4
          g.add_edge 10, v4, v5, 'created', weight:1.0
          g.add_edge 11, v4, v3, 'created', weight:0.4
          g.add_edge 12, v6, v3, 'created', weight:0.2
        end
      end

      # Returns the features as a hash
      def features
        {
          ignores_supplied_ids:false,
          is_persistent:false,
          is_rdf_model:false,
          is_wrapper:false,
          supports_boolean_property:true,
          supports_double_property:true,
          supports_duplicate_edges:true,
          supports_edge_index:false,
          supports_edge_iteration:true,
          supports_edge_key_index:false,
          supports_float_property:true,
          supports_indices:false,
          supports_integer_property:true,
          supports_key_indices:false,
          supports_long_property:true,
          supports_map_property:true,
          supports_mixed_list_property:true,
          supports_primitive_array_property:true,
          supports_self_loops:true,
          supports_serializable_object_property:true,
          supports_string_property:true,
          supports_threded_transactions:false,
          supports_transactions:false,
          supports_uniform_list_property:true,
          supports_vertex_index:false,
          supports_vertex_iteration:true,
          supports_vertex_key_index:false
        }
      end
    end

    attr_accessor :serializer
      
    # Returns a new instance
    # _block_ :: a block which is given the instance as the first argument 
    # to initialize it
    def initialize(&block)
      @serializer = Serializer::GraphMLSerializer.new self
      @vertices = {}
      @edges = {}
      @property_descriptions = {}
      block.call self if block
    end

    def items(type, *id) # :nodoc:
      items = case type
        when :vertex, :vertices
          @vertices
        when :edge, :edges
          @edges
        else
          raise ArgumentError.new('type should be :vertex or :edge')
        end

      if id.size == 2 # TODO: for the time being
        items.values.select{|e| e[id[0]] == id[1]}
      elsif 1 < id.size
        id.map{|i| items[i.to_s]}
      elsif id.size == 0
        items.values
      else
        case id.first
        when Array
          id.first.map{|i| items[i.to_s]}
        when :all
          items.values
        else
          items[id.first.to_s]
        end
      end
    end

    def vertex(*id)
      items :vertex, *id
    end

    def edge(*id)
      items :edge, *id
    end

    def add_vertex(id, v=nil)
      id = uid(@vertices.keys) unless id
      if v
        if v.is_a? Hash
          id = id.to_s
          v = Vertex.new self, id, v
        end
      else
        if id.is_a? Hash
          v = id
          id = (v[:id] || v['id']).to_s
        elsif id.respond_to?(:id)
          v = id
          id = v.id.to_s
        else
          id = id.to_s
          v = {}
        end
        v = Vertex.new self, id, v
      end
      raise ArgumentError.new "invalid id" unless id == v.id
      raise ArgumentError.new "#{id} already exists." if @vertices[id]

      @vertices[id] = v
    end

    def remove_vertex(id)
      id = id.id if id.is_a? Vertex
      v = @vertices.delete id.to_s
      if v
        v.out_edges.dup.each do |e| 
          remove_edge e
        end
        v.in_edges.dup.each do |e|
          remove_edge e
        end
      end
      v
    end

    def add_edge(id, from, to, label, opts={})
      id = uid(@edges.keys) unless id
      if id.is_a? Edge
        raise ArgumentError.new "#{id.id} already exists." if @edges[id.id]
        @edges[id.id] = id
      else
        id = id.to_s
        raise ArgumentError.new "#{id} already exists." if @edges[id]

        from = self.vertex(from.to_s) unless from.is_a? Vertex
        to = self.vertex(to.to_s) unless to.is_a? Vertex
        add_vertex from unless self.vertex(from.id)
        add_vertex to unless self.vertex(to.id)
        @edges[id] = Edge.new self, id, from, to, label, opts
      end
    end

    def remove_edge(id)
      if id.is_a? Edge
        e = id
        id = id.id
      else
        id = id.to_s
        e = @edges[id]
      end
      @edges.delete id
      if e
        e.source.out_edges.delete e
        e.target.in_edges.delete e
      end
      e
    end

    def load(filename)
      @serializer.load filename
    end

    def save(file)
      file = File.open file if file.is_a? String
      @serializer.save file
    end

    def find(*args)
      Graph::Vertex.new
    end

    def readonly
      dup.readonly!
    end

    def readonly!
      %w(add_vertex add_edge remove_vertex remove_edge load).each do |name|
        eval "def self.#{name}(*args); raise NoMethodError end"
      end
      def self.readonly?; true end
      self
    end

    def readonly?
      false
    end

    def shutdown
      # do nothing
    end

    def dup
      obj = self.class.new
      obj.instance_variable_set :@serializer, @serializer
      obj.instance_variable_set :@vertices, @vertices.dup
      obj.instance_variable_set :@edges, @edges.dup
      obj.instance_variable_set :@property_descriptions, @property_descriptions.dup
      obj
    end

    def uid(denies=[])
      id = "#{Time.now.to_i}-#{rand(10000)}"
      if denies.include? id
        uid denies
      else
        id
      end
    end

    def to_s
      "redgrape[vertices:#{@vertices.size} edges:#{@edges.size}]"
    end
  end
end
