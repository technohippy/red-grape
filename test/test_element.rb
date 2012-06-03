require 'test/unit'
require 'red_grape'
require 'red_grape/element'
require 'red_grape/property_description'

class ElementTest < Test::Unit::TestCase
  def test_new
    g = RedGrape::Graph.new
    v = RedGrape::Element.new g, property_description:{
      name:RedGrape::PropertyDescription.new('name', 'string'),
      sex:RedGrape::PropertyDescription.new('sex', 'string', 'male'),
      age:RedGrape::PropertyDescription.new('age', 'integer')
    }
    desc = v.instance_eval '@property_description'
    assert_equal 'name', desc[:name].name
    assert_equal 'string', desc[:name].type
    assert_nil desc[:name].default
    assert_equal 'male', desc[:sex].default

    v = RedGrape::Element.new g, property_description:{
      name:['name', 'string'],
      sex:['sex', 'string', 'male'],
      age:['age', 'integer']
    }
    desc = v.instance_eval '@property_description'
    assert_equal 'name', desc[:name].name
    assert_equal 'string', desc[:name].type
    assert_nil desc[:name].default
    assert_equal 'male', desc[:sex].default
    
    v = RedGrape::Element.new g, property_description:{
      name:{name:'name', type:'string'},
      sex:{name:'sex', type:'string', default:'male'},
      age:{name:'age', type:'integer'}
    }
    desc = v.instance_eval '@property_description'
    assert_equal 'name', desc[:name].name
    assert_equal 'string', desc[:name].type
    assert_nil desc[:name].default
    assert_equal 'male', desc[:sex].default
  end
end
