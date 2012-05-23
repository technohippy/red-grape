require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class InVPipe < Pipe::Base
      def pass(obj, context)
        target = obj.target
        if self.last?
          target
        else
          #context.push_history target do |ctx|
          context.push_history obj do |ctx|
            target.pass_through self.next, ctx
          end
        end
      end
    end
  end
end
