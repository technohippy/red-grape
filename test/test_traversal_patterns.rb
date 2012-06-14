require 'test/unit'
require 'red_grape'

class TraversalPatternsTest < Test::Unit::TestCase
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
    assert_equal %w(3 5), @graph.V('lang', 'java').take.map(&:id).sort
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
    v1 = @graph.vertex(1)

    assert_equal %w(josh lop vadas), v1.out.name.take.sort

    path = v1.out.name.path.take
    assert_equal 3, path.size
    assert_equal 3, path.first.size
    assert_equal '[[v[1], v[2], "vadas"], [v[1], v[4], "josh"], [v[1], v[3], "lop"]]', path.to_s

    path = v1.outE.inV.name.path.take
    assert_equal '[[v[1], e[7][1-knows->2], v[2], "vadas"], [v[1], e[8][1-knows->4], v[4], "josh"], [v[1], e[9][1-created->3], v[3], "lop"]]', path.to_s

    assert_equal(
      [["marko", 0.5, "vadas"], ["marko", 1.0, "josh"], ["marko", 0.4, "lop"]].to_s, 
      v1.outE.inV.path(proc{it.name}, proc{it.weight}, proc{it.name}).take.to_s
    )
  end

  def test_loop_pattern
    g = RedGrape.load_graph 'data/graph-example-2.xml'
    v89 = g.vertex 89
    assert_equal 36, g.v(89).outE.inV.path.take.size
    
    path = v89.outE.inV.loop(2){it.loops < 3}.path.take.first
    assert_equal '[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]]', path.to_s
    assert_equal RedGrape::Vertex, path[0].class
    assert_equal RedGrape::Edge, path[1].class
    assert_equal RedGrape::Vertex, path[2].class
    assert_equal RedGrape::Edge, path[3].class
    assert_equal RedGrape::Vertex, path[4].class

    path = v89.as('x').outE.inV.loop('x'){it.loops < 3}.path.take.first
    assert_equal '[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]]', path.to_s
    assert_equal RedGrape::Vertex, path[0].class
    assert_equal RedGrape::Edge, path[1].class
    assert_equal RedGrape::Vertex, path[2].class
    assert_equal RedGrape::Edge, path[3].class
    assert_equal RedGrape::Vertex, path[4].class

    path = v89.outE.inV.outE.inV.path.take.first
    assert_equal '[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]]', path.to_s
    assert_equal RedGrape::Vertex, path[0].class
    assert_equal RedGrape::Edge, path[1].class
    assert_equal RedGrape::Vertex, path[2].class
    assert_equal RedGrape::Edge, path[3].class
    assert_equal RedGrape::Vertex, path[4].class

    #assert_equal 70307, v89.out.loop(1, proc{it.loops < 4}).take.size #=> OK
    #assert_equal 71972, v89.out.loop(1, proc{it.loops < 4}, proc{true}).take.size #=> 70307
    #assert_equal 582, v89.out.loop(1, proc{it.loops < 4}, proc{it.object.id == '89'}).take.size #=> 564
  end

  # https://github.com/tinkerpop/gremlin/wiki/Split-Merge-Pattern
  def test_split_marge
    v1 = @graph.vertex 1
    #assert_equal ['ripple', 27, 'lop', 32], v1.out('knows').copy_split(_.out('created').name, _.age).fair_merge.take # TODO: not yet
    assert_equal [27, 'ripple', 'lop', 32], v1.out('knows').copy_split(_.out('created').name, _.age).exhaust_merge.take
  end
end
