require 'red_grape/pipe/underscore_pipe'

class Object
  include RedGrape::Pipe::Underscore

  def pass_through(pipe, context)
    pipe.pass self, context
  end
end
