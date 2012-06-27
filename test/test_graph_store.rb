require 'test/unit'
require 'red_grape'

class GraphStoreTest < Test::Unit::TestCase
  def test_graph_names
    gs = RedGrape::GraphStore.new
    assert_equal [], gs.graph_names
    gs << RedGrape.create_tinker_graph
    assert_equal [:tinkergraph], gs.graph_names
  end

  def test_get_graph
    gs = RedGrape::GraphStore.new
    g = RedGrape.create_tinker_graph
    gs << g
    assert_equal nil, gs.graph(:unknown)
    assert_equal g, gs.graph(:tinkergraph)
  end

  def test_put_graph
    gs = RedGrape::GraphStore.new
    g = RedGrape.create_tinker_graph
    gs.put_graph :newname, g
    assert_equal g, gs.graph(:newname)
    assert_equal :newname, g.name
    assert_equal nil, gs.graph(:tinkergraph)
  end

  def test_add_graph
    gs = RedGrape::GraphStore.new
    g = RedGrape.create_tinker_graph
    g.name = nil
    assert_raise(ArgumentError) {gs << g}
  end
end
