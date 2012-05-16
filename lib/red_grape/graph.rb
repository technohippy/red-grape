require 'red_grape/vertex'
require 'red_grape/vertex_group'
require 'red_grape/edge'
require 'red_grape/property_description'

module RedGrape
  class Graph
    NAMESPACES = {
      'xmlns' => 'http://graphml.graphdrawing.org/xmlns',
      'xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
    }

    class <<self
      def load(filename)
        self.new.load filename
      end
    end

    def initialize
      @vertices = {}
      @edges = {}
      @property_descriptions = {}
    end

    def vertex(id)
      @vertices[id.to_s]
    end
    alias v vertex

    def edge(id)
      @edges[id.to_s]
    end
    alias e edge

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
        @vertices[vertex._id] = vertex
      end
      nodes(xml, 'edge').each do |edge_elm|
        edge = Edge.new self, edge_elm['id'], edge_elm['source'], edge_elm['target'], 
          edge_elm['label'], :property_description => @property_descriptions['edge']
        data = nodes edge_elm, 'data'
        data.each do |data_elm|
          edge.set_property data_elm['key'], data_elm.children.first.to_s
        end
        @edges[edge._id] = edge
      end
    end

    def find(*args)
      Graph::Vertex.new
    end

    def nodes(xml, elm)
      xml.xpath(".//xmlns:#{elm}", NAMESPACES)
    end

=begin
    def to_s
      {:vertices => @vertices, :edges => @edges}.to_s
    end
=end
  end
end
