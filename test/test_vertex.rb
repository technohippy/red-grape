require 'test/unit'
require 'red_grape'

class VertexTest < Test::Unit::TestCase
  def test_to_s
    id = '12345'
    g = RedGrape::Graph.new
    v = RedGrape::Vertex.new g, id
    assert_equal "v[#{id}]", v.to_s
  end

  def test_set_property
    g = RedGrape::Graph.new
    v = RedGrape::Vertex.new g, '1234', property_description:{
      name:RedGrape::PropertyDescription.new('name', 'string'),
      sex:RedGrape::PropertyDescription.new('sex', 'string', 'male'),
      age:RedGrape::PropertyDescription.new('age', 'integer')
    }
    v.set_property :name, 'hello'
    assert_equal 'hello', v[:name]
    assert_equal 'male', v[:sex]
    assert_raise(ArgumentError) {v.set_property :age, 'not integer'}
  end

  def test_method_missing
    g = RedGrape::Graph.new
    v = RedGrape::Vertex.new g, '12345'
    v[:name] = 'yasushi'
    assert_equal 'yasushi', v[:name]
    assert_equal 'yasushi', v['name']
    assert_equal 'yasushi', v.name
    assert_raise(NoMethodError) {v.no_attr}
  end
end
