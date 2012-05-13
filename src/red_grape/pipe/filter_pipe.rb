require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class FilterPipe < Pipe::Base
      def pass(obj, context)
        filter = self.opts.first
        if context.eval :it => obj, &filter
          if self.last?
            obj 
          else
            context.push_history obj do |ctx|
              obj.pass_through self.next, ctx
            end
          end
        else
          nil
        end
      end
    end
  end
end
