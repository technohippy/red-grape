require 'nokogiri'
require 'red_grape/pipe/in_pipe'
require 'red_grape/pipe/out_pipe'
require 'red_grape/pipe/property_pipe'
require 'red_grape/pipe/paths_pipe'
require 'red_grape/pipe/filter_pipe'
require 'red_grape/pipe/transform_pipe'
require 'red_grape/pipe/side_effect_pipe'
require 'red_grape/pipe/if_then_else_pipe'
require 'red_grape/pipe/back_pipe'
require 'red_grape/graph'

module RedGrape
  module_function
  def load_graph(filename)
    Graph.load filename
  end
end

class Object
  def pass_through(pipe, context)
    pipe.pass self, context
  end
end
