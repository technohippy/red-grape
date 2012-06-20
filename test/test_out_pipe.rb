require 'test/unit'
require 'red_grape'

class OutPipeTest < Test::Unit::TestCase
  def setup
    @g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_out
    out = @g1.v(1).out[]
    assert_equal 3, out.size
    assert_equal RedGrape::Vertex, out[0].class
    assert_equal '2', out[0].id
    assert_equal RedGrape::Vertex, out[1].class
    assert_equal '4', out[1].id
    assert_equal RedGrape::Vertex, out[2].class
    assert_equal '3', out[2].id

    out2 = @g1.v(1).out.out[]
    assert_equal 2, out2.size
    assert_equal RedGrape::Vertex, out2[0].class
    assert_equal '5', out2[0].id
    assert_equal RedGrape::Vertex, out2[1].class
    assert_equal '3', out2[1].id
  end
end
