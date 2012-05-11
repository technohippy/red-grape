require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class PathsPipe < Pipe::Base
      def pass(obj, history)
        case obj
        when 'TODO'
        else
          hist = history + [obj]
          if self.last?
            hist
          else
            # TODO
            raise 'not implemented'
          end
        end
      end
    end
  end
end

