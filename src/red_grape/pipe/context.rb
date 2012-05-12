module RedGrape
  module Pipe
    class Context
      attr_accessor :it
      attr_reader :history
      def initialize
        @history = []
      end

      def push_history(obj, &block)
        @history.push obj
        ret = block.call self
        @history.pop
        ret 
      end

      def eval(args={}, &block)
        self.it = args[:it]
        instance_eval &block
      end
    end
  end
end
