class Object
  def pass_through(pipe, context)
    pipe.pass self, context
  end

  def _
    ret = self.dup
    ret.extend RedGrape::Pipe::Out
    ret.extend RedGrape::Pipe::OutE
    ret.extend RedGrape::Pipe::In
    ret.extend RedGrape::Pipe::SideEffect
    ret.extend RedGrape::Pipe::As
    ret.extend RedGrape::Pipe::Fill
    ret
  end
end
