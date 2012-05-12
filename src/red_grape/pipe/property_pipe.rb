require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class PropertyPipe < Pipe::Base
      def pipe_name
        "#{super}(#{@opts.first})"
      end

      def pass(obj, context)
        case obj
        when RedGrape::Vertex
          prop = obj[self.opts.first]
          if self.last?
            prop
          else
            context.push_history obj do |ctx|
              prop.pass_through self.next, ctx
            end
          end
        end
      end
    end
  end
end
