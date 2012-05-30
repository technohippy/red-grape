class Array
  def pass_through(pipe, context)
    map! {|e| pipe.pass e, context}
    graph_item_normalize
  end

  def graph_item_normalize
    reject! {|v| v.nil? or (v.respond_to?(:empty?) and v.empty?)}
    flatten!
    self
  end
end
