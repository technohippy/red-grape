require 'json'
require 'red_grape/pipe/underscore_pipe'

class Object
  include RedGrape::Pipe::Underscore

  def pass_through(pipe, context)
    pipe.pass self, context
  end

  def to_pretty_json
    JSON.pretty_generate self
  end
end
