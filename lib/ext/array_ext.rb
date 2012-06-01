class Array
  def pass_through(pipe, context)
    loops = context.loops
    map! do |e| 
      context.loops = loops
      pipe.pass e._, context # TODO
    end
    context.loops = loops
    normalize_for_graph
  end

  def normalize_for_graph
    reject! {|e| e.nil? or (e.respond_to?(:empty?) and e.empty?)}
    flatten!
    self
  end
end
