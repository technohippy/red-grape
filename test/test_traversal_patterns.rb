require 'test/unit'
require 'red_grape'
require 'red_grape/vertex_group'

class TraversalPatternsTest < Test::Unit::TestCase
=begin
  def setup
    @graph = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  # https://github.com/tinkerpop/gremlin/wiki/Backtrack-Pattern
  def test_backtrack_pattern
    assert_equal [29], @graph.V.out('knows').has('age', :gt, 30).back(2).age.take
    assert_equal [29], @graph.V.as('x').outE('knows').inV.has('age', :gt, 30).back('x').age.take
  end

  # https://github.com/tinkerpop/gremlin/wiki/Except-Retain-Pattern
  def test_except_retain_pattern
    assert_equal %w(2 3 4), @graph.v(1).out.take.map(&:id).sort
    assert_equal %w(3 5), @graph.v(1).out.out.take.map(&:id).sort
    assert_equal %w(5), @graph.v(1).out.aggregate(:x).out.except(:x).take.map(&:id).sort
    assert_equal %w(3), @graph.v(1).out.aggregate(:x).out.retain(:x).take.map(&:id).sort
  end

  # https://github.com/tinkerpop/gremlin/wiki/Flow-Rank-Pattern
  def test_flow_rank_pattern
    assert_equal %w(3 5), @graph.V('lang', 'java').map(&:id).sort
    software = []
    @graph.V('lang', 'java').fill(software).take
    assert_equal %w(3 5), software.map(&:id).sort
    assert_equal %w(marko josh peter josh), software._.in('created').name.take
    assert_equal(
      {'marko' => 1, 'josh' => 2, 'peter' => 1}, 
      software._.in('created').name.groupCount.cap.take
    )

    m = {}
    assert_equal %w(marko josh peter josh), software._.in('created').name.groupCount(m).take
    assert_equal({'marko' => 1, 'josh' => 2, 'peter' => 1}, m)
  end

  # https://github.com/tinkerpop/gremlin/wiki/Path-Pattern
  def test_path_pattern
    assert_equal %w(josh lop vadas), @graph.v(1).out.name.take.sort

    path = @graph.v(1).out.name.path.take
    assert_equal 3, path.size
    assert_equal 3, path.first.size
    assert_equal '[[v[1], v[2], "vadas"], [v[1], v[4], "josh"], [v[1], v[3], "lop"]]', path.to_s

    path = @graph.v(1).outE.inV.name.path.take
    assert_equal '[[v[1], e[7][1-knows->2], v[2], "vadas"], [v[1], e[8][1-knows->4], v[4], "josh"], [v[1], e[9][1-created->3], v[3], "lop"]]', path.to_s

    assert_equal(
      [["marko", "0.5", "vadas"], ["marko", "1.0", "josh"], ["marko", "0.4", "lop"]].to_s, 
      @graph.v(1).outE.inV.path(proc{it.name}, proc{it.weight}, proc{it.name}).take.to_s
    )
  end
=end

  def test_loop_pattern
    g = RedGrape.load_graph 'data/graph-example-2.xml'
    #assert_equal 36, g.v(89).outE.inV.path.take.size
    #assert_equal 36, g.v(89).outE.inV.loop(2){it.loops < 3}.path.take.size
    #assert_equal 36, g.v(89).outE.inV.loop(2){loops < 3}.path.take#.size
#assert_equal 36, g.v(89).outE.inV.loop(2){loops < 3}.path.take#.size
#puts g.v(89).outE.inV.loop(2){loops < 3}.path.take[0..5]
#g.v(89).outE.inV.loop(2){loops < 3}.path.take#.size
  end
end
