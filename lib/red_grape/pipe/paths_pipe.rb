require 'red_grape/pipe/base'
require 'red_grape/path_group'

module RedGrape
  module Pipe
    class PathsPipe < Pipe::Base
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

    PathPipe = PathsPipe
  end
end
