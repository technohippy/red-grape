require 'nokogiri'
require 'red_grape/vertex'
require 'red_grape/edge'
require 'red_grape/property_description'
require 'red_grape/serializer/graphml_serializer'

module RedGrape
  class Graph
    class << self
      def load(filename)
        self.new.load filename
      end

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
    end

    attr_accessor :serializer
      
    def initialize(&block)
      @serializer = Serializer::GraphMLSerializer.new self
      @vertices = {}
      @edges = {}
      @property_descriptions = {}
      block.call self if block
    end

    def items(type, *id)
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

    def v(*id)
      vertex(*id)._
    end
    alias V v

    def edge(*id)
      items :edge, *id
    end

    def e(*id)
      edge(*id)._
    end
    alias E e

    def add_vertex(id, v=nil)
      if v
        if v.is_a? Hash
          v = Vertex.new self, id, v
        end
      else
        if id.is_a? Hash
          v = id
          id = v[:id] || v['id']
        elsif id.respond_to?(:id)
          v = id
          id = v.id
        else
          v = {}
        end
        v = Vertex.new self, id, v
      end
      raise ArgumentError.new 'invalid id' unless id == v.id

      @vertices[id.to_s] = v
    end

    def add_edge(id, from, to, label, opts={})
      edge = if id.is_a? Edge
          id
        else
          id = id.to_s
          from = self.vertex[from.to_s] unless from.is_a? Vertex
          to = self.vertex[to.to_s] unless to.is_a? Vertex
          add_vertex from unless self.vertex(from.id)
          add_vertex to unless self.vertex(to.id)
          Edge.new self, id, from, to, label, opts
        end
      @edges[edge.id] = edge
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

    def to_s
      "redgrape[vertices:#{@vertices.size} edges:#{@edges.size}]"
    end
  end
end
