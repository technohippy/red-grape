require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class ScatterPipe < Pipe::Base
      def pass(obj, context)
        obj.should_pass_through_whole = false
        context.clear_gathering
        pass_next context, obj
      end
    end      
  end
end
