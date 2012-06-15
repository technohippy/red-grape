require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class GroupCountPipe < Pipe::Base
      def pass(obj, context)
        if self.opts.empty?
          #context.group({obj => 1}, self.next)
          context.group obj, self.next
        elsif self.opts.first.is_a? Proc
          #context.group({pipe_eval(it:obj, &self.opts.first) => 1}, self.next)
          context.group pipe_eval(it:obj, &self.opts.first), self.next
        else
          self.opts.first[obj] ||= 0
          self.opts.first[obj] += 1
        end
        obj
      end
    end
  end
end
