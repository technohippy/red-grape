require 'stringio'
require 'red_grape/vertex'
require 'red_grape/edge'
require 'red_grape/property_description'

module RedGrape
  class Graph
    # TODO: https://github.com/tinkerpop/blueprints/blob/bed2e64010882be66bf3b46d3c3e4b4ef4f6f2d9/blueprints-core/src/main/java/com/tinkerpop/blueprints/pgm/impls/tg/TinkerGraphFactory.java
    NAMESPACES = {
      'xmlns' => 'http://graphml.graphdrawing.org/xmlns',
      'xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
    }

    class << self
      def load(filename)
        if filename =~ /^<\?xml/
          self.new.load StringIO.new(filename)
        else
          self.new.load filename
        end
      end

      def create_tinker_graph
        g = self.new
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
        g
      end
    end

    def initialize
      @vertices = {}
      @edges = {}
      @property_descriptions = {}
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

    def load(file, type=:xml)
      file = File.open file if file.is_a? String
      case type
      when :xml
        parse_xml Nokogiri::XML(file)
      end
      self
    end

    # assumption: any sub-graph does not exist.
    def parse_xml(xml)
      nodes(xml, 'key').each do |key_elm|
        defaults = nodes key_elm, 'default'
        default = defaults.size == 0 ? nil : defaults.first.children.to_s
        prop = PropertyDescription.new key_elm['attr.name'], key_elm['attr.type'], default
        (@property_descriptions[key_elm['for']] ||= {})[key_elm['id']] = prop
      end
      nodes(xml, 'node').each do |node_elm|
        vertex = Vertex.new self, node_elm['id'], 
          :property_description => @property_descriptions['node']
        data = nodes node_elm, 'data'
        data.each do |data_elm|
          vertex.set_property data_elm['key'], data_elm.children.first.to_s
        end
        @vertices[vertex.id] = vertex
      end
      nodes(xml, 'edge').each do |edge_elm|
        edge = Edge.new self, edge_elm['id'], edge_elm['source'], edge_elm['target'], 
          edge_elm['label'], :property_description => @property_descriptions['edge']
        data = nodes edge_elm, 'data'
        data.each do |data_elm|
          edge.set_property data_elm['key'], data_elm.children.first.to_s
        end
        @edges[edge.id] = edge
      end
    end

    def find(*args)
      Graph::Vertex.new
    end

    def nodes(xml, elm)
      xml.xpath(".//xmlns:#{elm}", NAMESPACES)
    end

    def to_s
      "redgrape[vertices:#{@vertices.size} edges:#{@edges.size}]"
    end
  end
end
