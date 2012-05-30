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

    class <<self
      def load(filename)
        if filename =~ /^<\?xml/
          self.new.load StringIO.new(filename)
        else
          self.new.load filename
        end
      end
    end

    def initialize
      @vertices = {}
      @edges = {}
      @property_descriptions = {}
    end

    def vertex(*id)
      if id.size == 2 # TODO: for the time being
        @vertices.values.select{|e| e[id[0]] == id[1]}
      elsif 1 < id.size
        id.map{|i| @vertices[i.to_s]}
      elsif id.size == 0
        @vertices.values
      else
        case id.first
        when Array
          id.first.map{|i| @vertices[i.to_s]}
        when :all
          @vertices.values
        else
          @vertices[id.first.to_s]
        end
      end
    end
    alias v vertex
    alias V vertex

    def edge(id)
      @edges[id.to_s]
    end
    alias e edge

    def add_vertex(id, v=nil)
      if v
        if v.is_a? Hash
          v = Vertex.new self, id, v
        end
      else
        if id.is_a? Hash
          v = id
          id = v[:id] || v['id']
        else
          v = id
          id = v.id
        end
        v = Vertex.new self, id, v
      end
      raise ArgumentError.new 'invalid id' unless id == v.id

      @vertices[id.to_s] = v
    end

    def add_edge(id, label, from, to)
      edge = if id.is_a? Edge
          id
        else
          id = id.to_s
          from = self.vertex[from.to_s] unless from.is_a? Vertex
          to = self.vertex[to.to_s] unless to.is_a? Vertex
          add_vertex from unless self.vertex(from.id)
          add_vertex to unless self.vertex(to.id)
          Edge.new self, id, from, to, label
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
      {:vertices => @vertices, :edges => @edges}.to_s
    end
  end
end
