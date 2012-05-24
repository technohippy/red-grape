require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class IfThenElsePipe < Pipe::Base
      def pass(obj, context)
        condition = self.opts[0]
        then_block = self.opts[1]
        else_block = self.opts[2]
        ret =
          if context.eval({:it => obj}, &condition)
            context.eval({:it => obj}, &then_block)
          else
            context.eval({:it => obj}, &else_block)
          end
        ret = ret.take if ret.is_a? Pipe::Base
        pass_next context, ret
      end
    end
  end
end
