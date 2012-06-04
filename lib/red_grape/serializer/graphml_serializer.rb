require 'nokogiri'

module RedGrape
  module Serializer
    class GraphMLSerializer
      NAMESPACES = {
        'xmlns' => 'http://graphml.graphdrawing.org/xmlns',
        'xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
      }
      
      attr_reader :graph

      def initialize(graph)
        @graph = graph
      end

      def load(filename)
        if filename =~ /^<\?xml/
          parse_xml Nokogiri::XML(filename)
        else
          File.open(filename, 'r') do |file|
            parse_xml Nokogiri::XML(file)
          end
        end
        @graph
      end

      # assumption: any sub-graph does not exist.
      def parse_xml(xml)
        vertices = {}
        edges = {}
        property_descriptions = {}

        nodes(xml, 'key').each do |key_elm|
          defaults = nodes key_elm, 'default'
          default = defaults.size == 0 ? nil : defaults.first.children.to_s
          prop = PropertyDescription.new key_elm['attr.name'], key_elm['attr.type'], default
          (property_descriptions[key_elm['for']] ||= {})[key_elm['id']] = prop
        end
        @graph.instance_variable_set :@property_descriptions, property_descriptions

        nodes(xml, 'node').each do |node_elm|
          vertex = Vertex.new @graph, node_elm['id'], 
            :property_description => property_descriptions['node']
          data = nodes node_elm, 'data'
          data.each do |data_elm|
            vertex.set_property data_elm['key'], data_elm.children.first.to_s
          end
          vertices[vertex.id] = vertex
        end
        @graph.instance_variable_set :@vertices, vertices

        nodes(xml, 'edge').each do |edge_elm|
          edge = Edge.new @graph, edge_elm['id'], edge_elm['source'], edge_elm['target'], 
            edge_elm['label'], :property_description => property_descriptions['edge']
          data = nodes edge_elm, 'data'
          data.each do |data_elm|
            edge.set_property data_elm['key'], data_elm.children.first.to_s
          end
          edges[edge.id] = edge
        end
        @graph.instance_variable_set :@edges, edges
      end

      def nodes(xml, elm)
        xml.xpath(".//xmlns:#{elm}", NAMESPACES)
      end

      def save
      end
    end
  end
end
