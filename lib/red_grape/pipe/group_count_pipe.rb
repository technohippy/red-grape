require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class GroupCountPipe < Pipe::Base
      attr_accessor :reduce_function
      def pass(obj, context)
        @reduce_function = proc{it.size}
        if self.opts.empty?
          context.group self.next, obj
        elsif self.opts.first.is_a? Proc
          context.group self.next, pipe_eval(it:obj, &self.opts.first)
        else
          self.opts.first[obj] ||= 0
          self.opts.first[obj] += 1
        end
        obj
      end
    end
  end
end
