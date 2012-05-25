require 'test/unit'
require 'stringio'
require 'red_grape'

class GraphTest < Test::Unit::TestCase
  def test_vertex
    graph = RedGrape::Graph.new
    graph.add_vertex id:1, val:'a'
    graph.add_vertex id:2, val:'b'
    graph.add_vertex id:3, val:'c'

    assert_equal 3, graph.vertex.size
    assert_equal 1, graph.vertex(1).id
    #assert_equal 2, graph.vertex(1, 2).size # TODO
    assert_equal 3, graph.vertex(1, 2, 3).size
    assert_equal 2, graph.vertex([1, 2]).size
    assert_equal 3, graph.vertex(:all).size
  end

  def test_construct
    graph = RedGrape::Graph.new
    v1 = graph.add_vertex 1, name:'yasushi'
    v2 = graph.add_vertex 2, name:'ando'
    e12 = graph.add_edge 1, :fullname, v1, v2

    assert_equal 1, v1.out_edges.size
    assert_equal 0, v1.in_edges.size
    assert_equal e12, v1.out_edges.first

    assert_equal 0, v2.out_edges.size
    assert_equal 1, v2.in_edges.size
    assert_equal e12, v2.in_edges.first
  end

  def test_load
    data = <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
        http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
    <key id="weight" for="edge" attr.name="weight" attr.type="float"/>
    <key id="name" for="node" attr.name="name" attr.type="string"/>
    <graph id="G" edgedefault="directed">
        <node id="1">
            <data key="name">marko</data>
        </node>
        <node id="2">
            <data key="name">vadas</data>
        </node>
        <node id="3">
            <data key="name">lop</data>
        </node>
        <edge id="4" source="1" target="2" label="knows">
            <data key="weight">0.5</data>
        </edge>
        <edge id="5" source="1" target="3" label="knows">
            <data key="weight">1.0</data>
        </edge>
    </graph>
</graphml>
    EOS
    graph = RedGrape::Graph.load data
    assert_equal 'marko', graph.vertex(1).name
    assert_equal 'vadas', graph.vertex(2).name
    assert_equal 'lop', graph.vertex(3).name
    assert_equal 'marko', graph.edge(4).source.name
    assert_equal 'vadas', graph.edge(4).target.name
    assert_equal 'marko', graph.edge(5).source.name
    assert_equal 'lop', graph.edge(5).target.name
    
    graph = RedGrape::Graph.load StringIO.new(data)
    assert_equal 'marko', graph.vertex(1).name
    assert_equal 'vadas', graph.vertex(2).name
    assert_equal 'lop', graph.vertex(3).name
    assert_equal 'marko', graph.edge(4).source.name
    assert_equal 'vadas', graph.edge(4).target.name
    assert_equal 'marko', graph.edge(5).source.name
    assert_equal 'lop', graph.edge(5).target.name
  end
end
