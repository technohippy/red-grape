require 'test/unit'
require 'red_grape'

class PipeTest < Test::Unit::TestCase
  def setup
    @graph = RedGrape.load_graph 'data/graph-example-1.xml'
  end
  
  def test_set_auto_take
    assert !RedGrape::Pipe.auto_take
    RedGrape::Pipe.set_auto_take
    assert RedGrape::Pipe.auto_take
    RedGrape::Pipe.set_auto_take false
    assert !RedGrape::Pipe.auto_take
  end
end
