require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class GroupByPipe < Pipe::Base
      attr_accessor :reduce_function
      def pass(obj, context)
        key_function, value_function, @reduce_function = *self.opts
        value_function ||= proc{it}
        @reduce_function ||= proc{it}
        if self.opts.empty?
          context.group self.next, obj
        elsif self.opts.first.is_a? Proc
          context.group(
            self.next, 
            pipe_eval(it:obj, &key_function), 
            pipe_eval(it:obj, &value_function)
          )
        else
          self.opts.first[obj] ||= []
          self.opts.first[obj] << obj 
        end
        obj
      end
    end
  end
end

