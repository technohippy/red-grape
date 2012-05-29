class Array
  def _
    RedGrape::VertexGroup.new self.dup
  end

  def pass_through(pipe, context)
    map! {|e| pipe.pass e, context}
    reject! {|v| v.nil? or (v.respond_to?(:empty?) and v.empty?)}
    flatten!
    self
  end
end
