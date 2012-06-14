require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    module Underscore
      def _(*opts)
        UnderscorePipe.new self.dup, *opts#
      end
    end

    class UnderscorePipe < Pipe::Base
      def pass(obj, context)
        obj.pass_through self.next, context
      end
    end
  end
end
