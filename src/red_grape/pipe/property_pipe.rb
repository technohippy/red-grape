require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class PropertyPipe < Pipe::Base
      def pipe_name
        "#{super}(#{@opts.first})"
      end

      def pass(obj, history)
        case obj
        when RedGrape::Vertex
          prop = obj[self.opts.first]
          if self.last?
            prop
          else
            prop.pass_through self.next, :history => history + [obj]
          end
        end
      end
    end
  end
end
