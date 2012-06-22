require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class SelectPipe < Pipe::Base
      def pass(obj, context)
        if converter = self.opts[0]
          context.marks.inject({}) do |h, kv| 
            h[kv[0]] = context.eval(:it => kv[1], &converter)
            h
          end
        else
          context.marks
        end
      end
    end
  end
end
