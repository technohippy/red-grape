class Object
  def pass_through(pipe, context)
    pipe.pass self, context
  end

  def _
    self
  end
end
