require 'test/unit'
require 'red_grape'

# test the patterns shown in: http://markorodriguez.com/2011/08/03/on-the-nature-of-pipes/
class OnTheNatureOfPipesTest < Test::Unit::TestCase
  def setup
    @graph = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_basic
    assert_equal '1',
      @graph.v(1)._id

    assert_equal %w(2 3 4), 
      @graph.v(1).out.invoke.map(&:_id).sort

    assert_equal %w(josh lop vadas), 
      @graph.v(1).out.name.invoke.sort

    paths = @graph.v(1).out.name.paths.invoke
    assert_equal 3, 
      paths.size

    assert_equal [3, 3, 3], 
      paths.map(&:size)

    assert_equal %w[OutPipe PropertyPipe(name) PathsPipe], 
      @graph.v(1).out.name.paths.to_a
  end

  def test_filter
    assert_equal %w(2 4), 
      @graph.v(1).out('knows').invoke.map(&:_id).sort

    assert_equal %W(2), 
      @graph.v(1).out('knows').filter{it.age < 30}.invoke.map(&:_id).sort

    assert_equal %W(vadas),
      @graph.v(1).out('knows').filter{it.age < 30}.name.invoke.sort

    assert_equal [5], 
      @graph.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.invoke.sort

    assert_equal %w[OutPipe(knows) FilterPipe PropertyPipe(name) TransformPipe], 
      @graph.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.to_a
  end

  def test_side_effect
    assert_equal 'marko', 
      @graph.v(1).side_effect{@x = it}.invoke.name

    assert_equal %w(3), 
      @graph.v(1).side_effect{@x = it}.out('created').invoke.map(&:_id).sort

    assert_equal %w(1 4 6), 
      @graph.v(1).side_effect{@x = it}.out('created').in('created').invoke.map(&:_id).sort

    assert_equal %w(4 6), 
      @graph.v(1).side_effect{@x = it}.out('created').in('created').filter{it != @x}.invoke.map(&:_id).sort

    assert_equal %w(SideEffectPipe OutPipe(created) InPipe(created) FilterPipe), 
      @graph.v(1).side_effect{@x = it}.out('created').in('created').filter{it != @x}.to_a
  end

  def test_if_then_else
    #assert_equal ['vadas', ['ripple', 'lop']], 
    #  @graph.v(1).out('knows').if_then_else(proc{it.age < 30}, proc{it.name}, proc{it.out('created').name}).invoke.to_a
  end

  def test_back
    assert_equal %w(josh vadas),
      @graph.v(1).out('knows').name.invoke.to_a.sort

    assert_equal %w(vadas),
      @graph.v(1).out('knows').name.filter{it[0] == 'v'}.invoke.to_a

    assert_equal %w(2),
      @graph.v(1).out('knows').name.filter{it[0] == 'v'}.back(2).invoke.to_a.map(&:_id)

    assert_equal %w(OutPipe(knows) PropertyPipe(name) FilterPipe BackPipe),
      @graph.v(1).out('knows').name.filter{it[0] == 'v'}.back(2).to_a

    assert_equal %w(2 4),
      @graph.v(1).out('knows').as('here').name.filter{it[0] == 'v'}.back('here').invoke.to_a.map(&:_id)
  end

  def test_loop
    assert_equal %w(3 5),
      @graph.v(1).out.out.invoke.to_a.map(&:_id).sort

    assert_equal %w(3 5),
      @graph.v(1).out.loop(1){loops < 3}.invoke.to_a.map(&:_id).sort

    assert_equal %w(lop ripple),
      @graph.v(1).out.loop(1){loops < 3}.name.invoke.sort

    assert_equal %w(OutPipe LoopPipe PropertyPipe(name)),
      @graph.v(1).out.loop(1){loops < 3}.name.to_a
  end
end
