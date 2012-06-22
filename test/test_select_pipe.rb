require 'test/unit'
require 'red_grape'

class SelectPipeTest < Test::Unit::TestCase
  def setup
    @g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_select
    assert_equal(
      '[{"v1"=>v[1], "children"=>v[3]}, {"v1"=>v[1], "children"=>v[3]}, {"v1"=>v[1], "children"=>v[3]}]', 
      @g1.v(1).as('v1').out.as('children').select[].to_s
    )

    assert_equal(
      [
        {'v1'=>'marko', 'children'=>'vadas'},
        {'v1'=>'marko', 'children'=>'josh'},
        {'v1'=>'marko', 'children'=>'lop'}
      ],
      @g1.v(1).as('v1').out.as('children').select{it.name}[]
    )
  end
end
