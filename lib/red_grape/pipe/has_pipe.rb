require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class HasPipe < Pipe::Base
      def pass(obj, context)
        prop, cond, val = *self.opts
        cond = case cond
          when :gt; :>
          when :lt; :<
          else; cond
          end
        filter = proc{it[prop].send(cond, val)}

        # TODO: same as filter_pipe
        if context.eval :it => obj, &filter
          pass_next context, obj
        else
          nil
        end
      end
    end
  end
end
