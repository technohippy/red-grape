module RedGrape
  module Pipe
    class Context
      attr_accessor :it, :loops
      attr_reader :history, :grouping_items

      def initialize
        @history = []
        @marks = {}
        @aggregating_items = {}
        @aggregated_items = {}
        @grouping_items = []
        @loops = 1
      end

      def push_history(obj, &block)
        @history.push obj
        ret = block.call self
        @history.pop
        ret 
      end

      def mark!(label)
        @marks[label] = @history.last
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
        VertexGroup.new(ret).normalize
      end

      def group(val, next_pipe)
        @grouping_items << [val, next_pipe]
        val
      end

      def grouping?
        not @grouping_items.empty?
      end

      def resume_from_grouping
        obj, pipe = *@grouping_items.first # TODO: is '.first' ok?
        if pipe
          push_history obj do |ctx|
            obj.pass_through(pipe, ctx)
          end
        else
          obj
        end
      end

      def eval(args={}, &block)
        args.each {|k, v| self.send "#{k}=", v}
        instance_eval(&block)
      end
    end
  end
end
