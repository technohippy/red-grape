require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class BackPipe < Pipe::Base
      def pass(obj, context)
        label = self.opts.first
        obj = case label
          when Integer
            context.history[-label]
          else
            context.mark label
          end

        if self.last?
          obj 
        else
          context.push_history obj do |ctx|
            obj.pass_through self.next, ctx
          end
        end
      end
    end
  end
end
