class Array
  def pass_through(pipe, context)
    loops = context.loops
    map! do |e| 
      context.loops = loops
      pipe.pass e, context
    end
    context.loops = loops
    normalize_for_graph
  end

  def normalize_for_graph
    reject! {|e| e.nil? or (e.respond_to?(:empty?) and e.empty?)}
    flatten!
    self
  end
  
  def vertex_array?
    all?{|e| e.is_a? RedGrape::Vertex}
  end
  
  def edge_array?
    all?{|e| e.is_a? RedGrape::Edge}
  end

  def graph_item_array?
    vertex_array? or edge_array?
  end

  alias method_missing_without_prop_pipe method_missing
  def method_missing_with_prop_pipe(name, *args, &block)
    if graph_item_array?
      map! do |e| 
        begin
          e.send name, *args, &block
        rescue NoMethodError
          nil
        end
      end.compact!
    else
      method_missing_without_prop_pipe name, *args, &block
    end
  end
  alias method_missing method_missing_with_prop_pipe

  
end
