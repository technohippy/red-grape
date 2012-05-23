require 'red_grape/pipe/base'

module RedGrape
  module Pipe
    class GroupCountPipe < Pipe::Base
      def pass(obj, context)
        if self.opts.empty?
          context.group obj, self.next
        else
          self.opts.first[obj] ||= 0
          self.opts.first[obj] += 1
        end
        obj
      end
    end
  end
end
