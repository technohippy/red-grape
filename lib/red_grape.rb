require 'ext/object_ext'
require 'ext/array_ext'
require 'red_grape/pipe/in_pipe'
require 'red_grape/pipe/out_pipe'
require 'red_grape/pipe/property_pipe'
require 'red_grape/pipe/paths_pipe'
require 'red_grape/pipe/filter_pipe'
require 'red_grape/pipe/transform_pipe'
require 'red_grape/pipe/side_effect_pipe'
require 'red_grape/pipe/if_then_else_pipe'
require 'red_grape/pipe/back_pipe'
require 'red_grape/pipe/as_pipe'
require 'red_grape/pipe/loop_pipe'
require 'red_grape/pipe/has_pipe'
require 'red_grape/pipe/out_e_pipe'
require 'red_grape/pipe/in_v_pipe'
require 'red_grape/pipe/aggregate_pipe'
require 'red_grape/pipe/except_pipe'
require 'red_grape/pipe/retain_pipe'
require 'red_grape/pipe/fill_pipe'
require 'red_grape/pipe/group_count_pipe'
require 'red_grape/pipe/cap_pipe'
require 'red_grape/graph'

module RedGrape
  VERSION = '0.0.1'

  module_function
  def set_auto_take(val=true)
    Pipe.set_auto_take val
  end

  def load_graph(filename)
    Graph.load filename
  end

  def create_tinker_graph
    Graph.create_tinker_graph
  end
end
