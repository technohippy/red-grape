require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class PathsPipe < Pipe::Base
      def pass(obj, context)
        case obj
        when 'TODO'
        else
          context.push_history obj do |ctx|
            if self.last?
              ctx.history.dup
            else
              # TODO
              raise 'not implemented'
            end
          end
        end
      end
    end
  end
end

