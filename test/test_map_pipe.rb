require 'test/unit'
require 'red_grape'

class MapPipeTest < Test::Unit::TestCase
  def setup
    @g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_map
    assert_equal [
      {"name"=>"marko", "age"=>29},
      {"name"=>"vadas", "age"=>27},
      {"name"=>"lop", "lang"=>"java"},
      {"name"=>"josh", "age"=>32},
      {"name"=>"ripple", "lang"=>"java"},
      {"name"=>"peter", "age"=>35}
    ] , @g1.V.map[]

    assert_equal({"name"=>"marko", "age"=>29}, @g1.v(1).map[])
  end
end
