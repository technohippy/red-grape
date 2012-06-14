require 'red_grape/pipe/context'

module RedGrape
  module Pipe
    class CopySplitPipe < Pipe::Base
      def initialize(prev, *opts, &block)
        super
        @opts2 = @opts.dup # TODO: bug!
      end

      def pass(obj, context)
        #pipelines = self.opts.map do |pipeline|
        pipelines = @opts2.map do |pipeline| # TODO: opts2??
          pipe = pipeline.first_pipe
          pipe.prev = obj
          pipe
        end
        pass_next context, Pipelines.new(pipelines)
      end
    end
  end
end
