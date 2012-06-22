module RedGrape
  module Pipe
    class Context
      attr_accessor :it, :loops
      attr_reader :history, :grouping_items, :marks

      def initialize
        @history = []
        @marks = {}
        @aggregating_items = {}
        @aggregated_items = {}
        @grouping_items = {}
        @gathering_items = []
        @counting_items = []
        @ordering_items = []
        @loops = 1
      end

      def push_history(obj, &block)
        @history.push obj
        ret = block.call self
        @history.pop
        ret 
      end

      def mark!(label, val=nil)
        @marks[label] = val || @history.last
      end

      def mark(label)
        @marks[label]
      end

      def aggregated_items(key)
        @aggregated_items[key.to_s.to_sym] ||= []
      end

      def aggregating_items(key)
        @aggregating_items[key.to_s.to_sym] ||= []
      end

      def aggregate(key, val, next_pipe)
        self.aggregating_items(key) << [val, next_pipe]
        val
      end

      def aggregating?
        not @aggregating_items.empty?
      end

      def resume_from_aggregating
        ret = []
        aggregating = @aggregating_items
        @aggregating_items = {}
        aggregating.each do |key, obj_and_pipes|
          obj_and_pipes.each do |obj_and_pipe|
            (@aggregated_items[key] ||= []) << obj_and_pipe.first
          end
        end

        aggregating.each do |key, obj_and_pipes|
          obj_and_pipes.each do |obj_and_pipe|
            obj, pipe = *obj_and_pipe
            push_history obj do |ctx|
              ret << obj.pass_through(pipe, ctx)
            end
          end
        end
        ret.normalize_for_graph
      end

      def group(next_pipe, key, val=key)
        (@grouping_items[key] ||= []) << [val, next_pipe]
        val
      end

      def grouping?
        not @grouping_items.empty?
      end

      def resume_from_grouping
        obj, pipe = *@grouping_items.values.first.first # TODO: '.first' is used to get next_pipe.
        if pipe
          push_history obj do |ctx|
            obj.pass_through pipe, ctx
          end
        else
          obj
        end
      end

      def gather(obj, next_pipe)
        @gathering_items << [obj, next_pipe]
      end

      def gathering?
        not @gathering_items.empty?
      end

      def clear_gathering
        @gathering_items.clear
      end

      def resume_from_gathering
        obj, pipe = *@gathering_items.first
        objs = @gathering_items.map &:first
        objs.should_pass_through_whole = true
        if pipe
          push_history objs do |ctx|
            pipe.prev = objs
            pipe.take ctx
          end
        else
          objs
        end
      end

      def count(obj, next_pipe)
        @counting_items << obj
      end

      def counting?
        not @counting_items.empty?
      end

      def resume_from_counting
        size = @counting_items.size
        @counting_items.clear
        size
      end

      def order(obj, next_pipe)
        @ordering_items << obj
      end

      def ordering?
        not @ordering_items.empty?
      end

      def resume_from_ordering
        @ordering_items.sort
      end


      def eval(args={}, &block)
        args.each {|k, v| self.send "#{k}=", v}
        instance_eval(&block)
      end
    end
  end
end
