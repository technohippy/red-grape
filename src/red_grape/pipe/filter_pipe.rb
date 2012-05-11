require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class FilterPipe < Pipe::Base
      def pass(obj, history)
        case obj
        when RedGrape::Vertex
          filter = self.opts.first
          if obj.instance_eval &filter
            if self.last?
              obj 
            else
              obj.pass_through self.next, :history => history + [obj]
            end
          else
            nil
          end
        end
      end
    end
  end
end
