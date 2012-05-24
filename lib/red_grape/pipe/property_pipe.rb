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
          pass_next context, obj, prop
        end
      end
    end
  end
end
