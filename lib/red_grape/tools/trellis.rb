require 'drb/drb'
require 'red_grape'
require 'red_grape/graph_store'

module RedGrape
  module Tools
    class Trellis < GraphStore
      DEFAULT_PORT = 28282

      class << self
        def start(port=nil, filename=nil, &block)
          self.new(filename).start port, &block
        end

        def uri(port=nil)
          "druby://localhost:#{port || DEFAULT_PORT}"
        end

        def open(port=nil)
          DRbObject.new_with_uri(uri port)
        end
      end

      def initialize(filename=nil)
        @filename = filename
        @graphs =
          if @filename && File.exist?(@filename)
            File.open @filename, 'r' do |file|
              Marshal.load file
            end
          else
            {tinker:RedGrape::Graph.create_tinker_graph}
          end
      end

      def start(port=nil, &block)
        at_exit do
          File.open @filename, 'w' do |file|
            Marshal.dump @graphs, file
          end if @filename
        end

        DRb.start_service self.class.uri(port), self
        block.call if block
        sleep
      end
    end
  end
end
