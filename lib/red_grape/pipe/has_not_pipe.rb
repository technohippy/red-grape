require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class HasNotPipe < Pipe::Base
      def pass(obj, context)
        prop, val = *self.opts
        filter = proc{it[prop] == val}

        # TODO: same as filter_pipe (has_pipe)
        unless context.eval :it => obj, &filter
          pass_next context, obj
        else
          nil
        end
      end
    end
  end
end
