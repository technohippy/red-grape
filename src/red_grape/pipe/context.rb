module RedGrape
  module Pipe
    class Context
      attr_accessor :it, :loops
      attr_reader :history

      def initialize
        @history = []
        @marks = {}
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

      def eval(args={}, &block)
        self.it = args[:it]
        instance_eval &block
      end
    end
  end
end
