require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class GroupByPipe < Pipe::Base
      def pass(obj, context)
        key_function, value_function, reduce_function = *self.opts
        if self.opts.empty?
          context.group({obj => obj}, self.next)
        elsif self.opts.first.is_a? Proc
          context.group({pipe_eval(it:obj, &self.opts.first) => obj}, self.next)
        else
          self.opts.first[obj] ||= []
          self.opts.first[obj] << obj 
        end
        obj
      end
    end
  end
end

