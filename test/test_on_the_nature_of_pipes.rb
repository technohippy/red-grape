require 'test/unit'
require 'red_grape'

# test the patterns shown in: http://markorodriguez.com/2011/08/03/on-the-nature-of-pipes/
class OnTheNatureOfPipesTest < Test::Unit::TestCase
  def setup
    @graph = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  def test_basic
    assert_equal '1',
      @graph.v(1).take.id

    assert_equal %w(2 3 4), 
      @graph.v(1).out.take.map(&:id).sort

    assert_equal %w(josh lop vadas), 
      @graph.v(1).out.name.take.sort

    paths = @graph.v(1).out.name.paths.take
    assert_equal 3, 
      paths.size

    assert_equal [4, 4, 4], 
      paths.map(&:size)

    assert_equal %w[V Out Property(name) Paths], 
      @graph.v(1).out.name.paths.to_a
  end

  def test_filter
    assert_equal %w(2 4), 
      @graph.v(1).out('knows').take.map(&:id).sort

    assert_equal %w(2), 
      @graph.v(1).out('knows').filter{it.age < 30}.take.map(&:id).sort

    assert_equal %w(vadas),
      @graph.v(1).out('knows').filter{it.age < 30}.name.take.sort

    assert_equal [5], 
      @graph.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.take.sort

    assert_equal %w[V Out(knows) Filter Property(name) Transform], 
      @graph.v(1).out('knows').filter{it.age < 30}.name.transform{it.size}.to_a
  end

  def test_side_effect
    assert_equal 'marko', 
      @graph.v(1).side_effect{@x = it}.take.name

    assert_equal %w(3), 
      @graph.v(1).side_effect{@x = it}.out('created').take.map(&:id).sort

    assert_equal %w(1 4 6), 
      @graph.v(1).side_effect{@x = it}.out('created').in('created').take.map(&:id).sort

    assert_equal %w(4 6), 
      @graph.v(1).side_effect{@x = it}.out('created').in('created').filter{it != @x}.take.map(&:id).sort

    assert_equal %w(V SideEffect Out(created) In(created) Filter), 
      @graph.v(1).side_effect{@x = it}.out('created').in('created').filter{it != @x}.to_a
  end

  def test_if_then_else
    #assert_equal ['vadas', ['ripple', 'lop']], 
    assert_equal ['vadas', 'ripple', 'lop'], 
      @graph.v(1).out('knows').if_then_else(proc{it.age < 30}, proc{it.name}, proc{it.out('created').name}).take.to_a
  end

  def test_back
    assert_equal %w(josh vadas),
      @graph.v(1).out('knows').name.take.to_a.sort

    assert_equal %w(vadas),
      @graph.v(1).out('knows').name.filter{it[0] == 'v'}.take.to_a

    assert_equal %w(2),
      @graph.v(1).out('knows').name.filter{it[0] == 'v'}.back(2).take.to_a.map(&:id)

    assert_equal %w(V Out(knows) Property(name) Filter Back),
      @graph.v(1).out('knows').name.filter{it[0] == 'v'}.back(2).to_a

    assert_equal %w(2),
      @graph.v(1).out('knows').as('here').name.filter{it[0] == 'v'}.back('here').take.to_a.map(&:id)
  end

  def test_loop
    assert_equal %w(3 5),
      @graph.v(1).out.out.take.to_a.map(&:id).sort

    assert_equal %w(3 5),
      @graph.v(1).out.loop(1){loops < 3}.take.to_a.map(&:id).sort

    assert_equal %w(lop ripple),
      @graph.v(1).out.loop(1){loops < 3}.name.take.sort

    assert_equal %w(V Out Loop Property(name)),
      @graph.v(1).out.loop(1){loops < 3}.name.to_a
  end
end
