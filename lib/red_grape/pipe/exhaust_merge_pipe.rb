require 'red_grape/pipe/context'

module RedGrape
  module Pipe
    class ExhaustMergePipe < Pipe::Base
      def pass(obj, context)
        pass_next context, obj.take(context)
      end
    end
  end
end

