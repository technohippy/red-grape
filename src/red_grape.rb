require 'nokogiri'
require 'red_grape/graph'
require 'red_grape/pipe/out_pipe'
require 'red_grape/pipe/property_pipe'
require 'red_grape/pipe/paths_pipe'
require 'red_grape/pipe/filter_pipe'
require 'red_grape/pipe/transform_pipe'

module RedGrape
  module_function
  def load_graph(filename)
    Graph.load filename
  end
end

class Object
  def pass_through(pipe, context)
    history = context[:history].dup
    pipe.pass self, history
  end
end
