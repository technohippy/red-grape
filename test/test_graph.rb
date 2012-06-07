require 'test/unit'
require 'red_grape'

class GraphTest < Test::Unit::TestCase
  def test_vertex
    graph = RedGrape::Graph.new
    graph.add_vertex id:1, val:'a'
    graph.add_vertex id:2, val:'b'
    graph.add_vertex id:3, val:'c'

    assert_equal 3, graph.vertex.size
    assert_equal '1', graph.vertex(1).id
    #assert_equal 2, graph.vertex(1, 2).size # TODO
    assert_equal 3, graph.vertex(1, 2, 3).size
    assert_equal 2, graph.vertex([1, 2]).size
    assert_equal 3, graph.vertex(:all).size
  end

  def test_construct
    graph = RedGrape::Graph.new
    v1 = graph.add_vertex 1, name:'yasushi'
    v2 = graph.add_vertex 2, name:'ando'
    e12 = graph.add_edge 1, v1, v2, :fullname

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
  end

  def test_features
    features = RedGrape::Graph.features
    assert_equal Hash, features.class
    assert features.keys.include?(:ignores_supplied_ids)
  end

  def test_add_vertex
    g = RedGrape::Graph.new
    g.add_vertex id:1, val:'a'
    v1 = g.v(1)
    assert_equal '1', v1.id
    assert_equal 'a', v1.val

    g.add_vertex '2', val:'b'
    v2 = g.v(2)
    assert_equal '2', v2.id
    assert_equal 'b', v2.val

    v3 = RedGrape::Vertex.new nil, 3, val:'c'
    g.add_vertex '3', v3
    assert_equal v3, g.v(3)
    assert_equal '3', v3.id
    assert_equal 'c', v3.val

    assert_raise(ArgumentError) do
      g.add_vertex '4', v3
    end
  end

  def test_remove_vertex
    g = RedGrape::Graph.new
    v1 = g.add_vertex 1
    v2 = g.add_vertex 2
    v3 = g.add_vertex 3
    e12 = g.add_edge 1, 1, 2, :connect
    e23 = g.add_edge 1, 2, 3, :connect
    assert v1.out_edges.map(&:id).include?(e12.id)
    assert v2.in_edges.map(&:id).include?(e12.id)
    assert v2.out_edges.map(&:id).include?(e23.id)
    assert v3.in_edges.map(&:id).include?(e23.id)

    g.remove_vertex v2
    assert !v1.out_edges.map(&:id).include?(e12.id)
    assert !v3.in_edges.map(&:id).include?(e23.id)

    g = RedGrape.create_tinker_graph
    assert_equal 6, g.v.size
    assert_equal 6, g.e.size
    g.remove_vertex 1
    assert_equal 5, g.v.size
    assert_equal 3, g.e.size
  end

  def test_add_edge
    g = RedGrape::Graph.new
    v1 = g.add_vertex 1
    v2 = g.add_vertex 2
    v3 = g.add_vertex 3
    e12 = g.add_edge 1, 1, 2, :connect
    e23 = g.add_edge 1, 2, 3, :connect
    assert v1.out_edges.map(&:id).include?(e12.id)
    assert v2.in_edges.map(&:id).include?(e12.id)
    assert v2.out_edges.map(&:id).include?(e23.id)
    assert v3.in_edges.map(&:id).include?(e23.id)
  end

  def test_remove_edge
    g = RedGrape::Graph.new
    v1 = g.add_vertex 1
    v2 = g.add_vertex 2
    v3 = g.add_vertex 3
    e12 = g.add_edge 1, 1, 2, :connect
    e23 = g.add_edge 1, 2, 3, :connect
    assert v1.out_edges.map(&:id).include?(e12.id)
    assert v2.in_edges.map(&:id).include?(e12.id)
    assert v2.out_edges.map(&:id).include?(e23.id)
    assert v3.in_edges.map(&:id).include?(e23.id)

    g.remove_edge e12
    assert !v1.out_edges.map(&:id).include?(e12.id)
    assert !v2.in_edges.map(&:id).include?(e12.id)
    assert v2.out_edges.map(&:id).include?(e23.id)
    assert v3.in_edges.map(&:id).include?(e23.id)
  end

  def test_readonly
    g1 = RedGrape::Graph.new

    assert !g1.readonly?
    g1.add_vertex 1

    g2 = g1.readonly
    assert !g1.readonly?
    assert g2.readonly?
    assert_equal 1, g2.v.size
    assert_raise(NoMethodError) do
      g2.add_vertex 2
    end 
    g1.add_vertex 2
    assert_equal 2, g1.v.size
    assert_equal 1, g2.v.size

    g1.readonly!
    assert g1.readonly?
    assert_raise(NoMethodError) do
      g1.add_vertex 3
    end 
    assert_equal 2, g1.v.size
  end
end
