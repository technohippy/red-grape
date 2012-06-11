require 'drb/drb'
require 'irb'
require 'irb/completion'
require 'red_grape'
require 'red_grape/tools/graph_store'

module RedGrape
  module Tools
    class IRG
      module Help
        module_function
        def redgrape?(key=nil)
          case key
          when NilClass
            puts help_message
            :OK
          when 'pipe', 'pipes', :pipe, :pieps
            puts pipe_help_message
            :OK
          else
            puts '?'
            :NG
          end
        end

        def help_message
          <<-EOS
Subcommands:
  redgrape? :pipe         : list all pipes.
          EOS
  #redgrape? '[pipe name]' : describe the given pipe.
        end

        def pipe_help_message
          pipes = RedGrape::Pipe.constants.map(&:to_s).select{|p| 
            p =~ /.*Pipe$/}.map{|p| underscore p.sub(/Pipe$/, '')}
          "Available pipes:\n  #{pipes.sort.join ', '}"
        end

        def underscore(str)
          str.sub(/^[A-Z]/){|p| p.downcase}.gsub(/([a-z])([A-Z])/){"#{$1}_#{$2.downcase}"}
        end

        def camelcase(str)
          str.sub(/^[a-z]/){|p| p.upcase}.gsub(/_([a-z])/){"#{$1.upcase}"}
        end
      end

      class << self
        def start(port=nil, &block)
          self.new.start port, &block
        end
      end

      def start(port=nil, &block)
        Kernel.module_eval %Q{
          def redgrape?(key=nil)
            RedGrape::IRG::Help.redgrape? key
          end
          alias rg? redgrape?
        }

        RedGrape.set_auto_take
        $store = RedGrape::Tools::GraphStore.open port if port
        block.call if block
        IRB.start
      end
    end
  end
end
