require 'test/unit'
require 'red_grape'

class TraversalPatternsTest < Test::Unit::TestCase
  def setup
    @g1 = RedGrape.load_graph 'data/graph-example-1.xml'
  end

  # https://github.com/tinkerpop/gremlin/wiki/Backtrack-Pattern
  def test_backtrack_pattern
    assert_equal [29], @g1.V.out('knows').has('age', :gt, 30).back(2).age[]
    assert_equal [29], @g1.V.as('x').outE('knows').inV.has('age', :gt, 30).back('x').age[]
  end

  # https://github.com/tinkerpop/gremlin/wiki/Except-Retain-Pattern
  def test_except_retain_pattern
    assert_equal %w(2 3 4), @g1.v(1).out[].map(&:id).sort
    assert_equal %w(3 5), @g1.v(1).out.out[].map(&:id).sort
    assert_equal %w(5), @g1.v(1).out.aggregate(:x).out.except(:x)[].map(&:id).sort
    assert_equal %w(3), @g1.v(1).out.aggregate(:x).out.retain(:x)[].map(&:id).sort
  end

  # https://github.com/tinkerpop/gremlin/wiki/Flow-Rank-Pattern
  def test_flow_rank_pattern
    assert_equal %w(3 5), @g1.V('lang', 'java')[].map(&:id).sort
    software = []
    @g1.V('lang', 'java').fill(software)[]
    assert_equal %w(3 5), software.map(&:id).sort
    assert_equal %w(marko josh peter josh), software._.in('created').name[]
    assert_equal(
      {'marko' => 1, 'josh' => 2, 'peter' => 1}, 
      software._.in('created').name.groupCount.cap[]
    )

    m = {}
    assert_equal %w(marko josh peter josh), software._.in('created').name.groupCount(m)[]
    assert_equal({'marko' => 1, 'josh' => 2, 'peter' => 1}, m)
  end

  # https://github.com/tinkerpop/gremlin/wiki/Path-Pattern
  def test_path_pattern
    v1 = @g1.vertex(1)

    assert_equal %w(josh lop vadas), v1.out.name[].sort

    path = v1.out.name.path[]
    assert_equal 3, path.size
    assert_equal 3, path.first.size
    assert_equal '[[v[1], v[2], "vadas"], [v[1], v[4], "josh"], [v[1], v[3], "lop"]]', path.to_s

    path = v1.outE.inV.name.path[]
    assert_equal '[[v[1], e[7][1-knows->2], v[2], "vadas"], [v[1], e[8][1-knows->4], v[4], "josh"], [v[1], e[9][1-created->3], v[3], "lop"]]', path.to_s

    assert_equal(
      [["marko", 0.5, "vadas"], ["marko", 1.0, "josh"], ["marko", 0.4, "lop"]].to_s, 
      v1.outE.inV.path(_{it.name}, _{it.weight}, _{it.name})[].to_s
    )
  end

  def test_loop_pattern
    @g2 ||= RedGrape.load_graph 'data/graph-example-2.xml'
    v89 = @g2.vertex 89
    assert_equal 36, v89.outE.inV.path[].size
    
    path = v89.outE.inV.loop(2){it.loops < 3}.path[].first
    assert_equal '[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]]', path.to_s
    assert_equal RedGrape::Vertex, path[0].class
    assert_equal RedGrape::Edge, path[1].class
    assert_equal RedGrape::Vertex, path[2].class
    assert_equal RedGrape::Edge, path[3].class
    assert_equal RedGrape::Vertex, path[4].class

    path = v89.as('x').outE.inV.loop('x'){it.loops < 3}.path[].first
    assert_equal '[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]]', path.to_s
    assert_equal RedGrape::Vertex, path[0].class
    assert_equal RedGrape::Edge, path[1].class
    assert_equal RedGrape::Vertex, path[2].class
    assert_equal RedGrape::Edge, path[3].class
    assert_equal RedGrape::Vertex, path[4].class

    path = v89.outE.inV.outE.inV.path[].first
    assert_equal '[v[89], e[7006][89-followed_by->127], v[127], e[7786][127-sung_by->340], v[340]]', path.to_s
    assert_equal RedGrape::Vertex, path[0].class
    assert_equal RedGrape::Edge, path[1].class
    assert_equal RedGrape::Vertex, path[2].class
    assert_equal RedGrape::Edge, path[3].class
    assert_equal RedGrape::Vertex, path[4].class

    #assert_equal(
    #  70307, 
    #  v89.out.loop(1, _{it.loops < 4})[].size
    #) #=> OK

    #assert_equal(
    #  71972, 
    #  v89.out.loop(1, _{it.loops < 4}, _{true})[].size
    #) #=> 70307

    #assert_equal(
    #  582, 
    #  v89.out.loop(1, _{it.loops < 4}, _{it.object.id == '89'})[].size 
    #) #=> 564
  end

  # https://github.com/tinkerpop/gremlin/wiki/Split-Merge-Pattern
  def test_split_merge_pattern
    v1 = @g1.vertex 1

    #assert_equal(
    #  ['ripple', 27, 'lop', 32], 
    #  v1.out('knows').copy_split(_.out('created').name, _.age).fair_merge[]
    #) # TODO: not yet

    assert_equal(
      [27, 'ripple', 'lop', 32], 
      v1.out('knows').copy_split(_.out('created').name, _.age).exhaust_merge[]
    )
  end

  # https://github.com/tinkerpop/gremlin/wiki/MapReduce-Pattern
  def test_map_reduce_pattern
    @g2 ||= RedGrape.load_graph 'data/graph-example-2.xml'
    assert_equal(
      {'cover'=>313, 'original'=>184}, 
      @g2.V.has_not('song_type', nil).group_count(_{it.song_type}).cap[]
    )

    ret = @g2.V.has_not('song_type', nil).group_by(_{it.song_type}, _{it}).cap[]
    assert_equal 2, ret.keys.size
    assert_equal 313, ret.values[0].size
    assert ret.values[0].all?{|e| e.is_a? RedGrape::Vertex}
    assert_equal 184, ret.values[1].size
    assert ret.values[1].all?{|e| e.is_a? RedGrape::Vertex}

    ret = @g2.V.has_not('song_type', nil).group_by(_{it.song_type}, _{it.name}).cap[]
    assert_equal 2, ret.keys.size
    assert_equal 313, ret.values[0].size
    assert ret.values[0].all?{|e| e.is_a? String}
    assert_equal 184, ret.values[1].size
    assert ret.values[1].all?{|e| e.is_a? String}
    assert_equal 'HEY BO DIDDLEY', ret.values[0][0]
    assert_equal 'BERTHA', ret.values[1][0]

    ret = @g2.V.has_not('song_type', nil).group_by(_{it.song_type}, _{1}).cap[]
    assert_equal 2, ret.keys.size
    assert ret.values[0].all?{|e| e == 1}
    assert ret.values[1].all?{|e| e == 1}

    ret = @g2.V.has_not('song_type', nil).group_by(_{it.song_type}, _{1}, _{it.size}).cap[]
    assert_equal 313, ret.values[0]
    assert_equal 184, ret.values[1]

    ret = @g2.V.has_not('song_type', nil).group_by(_{it.song_type}, _{it.out('sung_by')[]}, _{it._.name.group_count.cap[]}).cap[]
    assert_equal 66, ret[0]['cover']['Weir']
    assert_equal 33, ret[0]['original']['Weir']
  end

  # https://github.com/tinkerpop/gremlin/wiki/Depth-First-vs.-Breadth-First
  def test_depth_first_vs_bredth_first
    assert_equal %w(1 4 6), @g1.v(1).out_e('created').in_v.in_e('created').out_v[].map(&:id)
    assert_equal %w(1 4 6), @g1.v(1).out_e('created').gather.scatter.in_v.gather.scatter.in_e('created').gather.scatter.out_v.gather.scatter[].map(&:id)
  end
end
