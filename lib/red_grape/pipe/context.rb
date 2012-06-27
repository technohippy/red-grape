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

        @accumulated_items = {}

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

      def accumulate(key, obj, &block)
        items = (@accumulated_items[key] ||= {})
        (items[:objects] ||= []) << obj
        items[:resume_block] = block if block
      end

      def accumulating?(key=nil)
        if key
          not @accumulated_items[key].nil?
        else
          @accumulated_items.any?{|k, _| accumulating? k}
        end
      end

      def clear_accumulating(key=nil)
        if key
          @accumulated_items[key] = nil if @accumulated_items[key]
        else
          @accumulated_items.clear
        end
      end

      def resume_from_accumulating(key=nil, should_clear=true)
        ret = nil
        if key
          if items = @accumulated_items[key]
            ret = items[:resume_block].call(items[:objects]) if items[:resume_block]
          end
          @accumulated_items[key] = nil if should_clear
        else
          @accumulated_items.each do |k, _|
            ret = resume_from_accumulating k
          end
        end
        ret
      end

      def gather(obj, next_pipe)
        accumulate :gather, obj do |objs|
          objs = objs.dup
          objs.should_pass_through_whole = true
          if next_pipe
            push_history objs do |ctx|
              next_pipe.prev = objs
              next_pipe.take ctx
            end
          else
            objs
          end
        end
      end

      def gathering?
        accumulating? :gather
      end

      def resume_from_gathering
        resume_from_accumulating :gather
      end

      def count(obj, next_pipe)
        accumulate :count, obj do |objs|
          objs.size
        end
      end

      def counting?
        accumulating? :count
      end

      def resume_from_counting
        resume_from_accumulating :count
      end

      def order(obj, next_pipe)
        accumulate :order, obj do |objs|
          objs.sort
        end
      end

      def ordering?
        accumulating? :order
      end

      def resume_from_ordering
        resume_from_accumulating :order
      end

      def eval(args={}, &block)
        args.each {|k, v| self.send "#{k}=", v}
        instance_eval(&block)
      end
    end
  end
end
