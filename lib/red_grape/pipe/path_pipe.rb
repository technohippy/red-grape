require 'forwardable'
require 'red_grape/pipe/base'

module RedGrape
  class PathGroup
    extend Forwardable
    def_delegators :@paths, :size, :to_s, :[], :first, :last

    def initialize(ary)
      @paths = ary.dup
    end
  end

  module Pipe
    class PathPipe < Pipe::Base
      def pass(obj, context)
        context.push_history obj do |ctx|
          history = ctx.history.dup
          if self.opts.empty?
            PathGroup.new history
          else
            ary = []
            history.each_with_index do |h, index|
              prc = self.opts[index]
              if prc
                context.it = h
                ary << context.eval(&prc)
              else
                ary << h
              end
            end 
            PathGroup.new ary
          end
        end
      end
    end

    PathsPipe = PathPipe
  end
end
