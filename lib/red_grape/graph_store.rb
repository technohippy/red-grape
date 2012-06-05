require 'drb/drb'
require 'red_grape'

module RedGrape
  class GraphStore
    def self.start(uri=nil, filename=nil, &block)
      self.new(filename).start uri, &block
    end

    def initialize(filename=nil)
      @filename = filename
      @graphs =
        if @filename
          File.open @filename, 'r' do |file|
            Marshal.load file
          end
        else
          {tinker:RedGrape::Graph.create_tinker_graph}
        end
    end

    def graphs
      @graphs.keys.sort
    end

    def graph(key)
      @graphs[key.to_sym]
    end

    def start(uri, &block)
      at_exit do
        File.open @filename, 'w' do |file|
          Marshal.dump @graphs, file
        end if @filename
      end

      DRb.start_service uri, self
      block.call if block
      sleep
    end
  end
end
