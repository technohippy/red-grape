require 'drb/drb'
require 'red_grape'

module RedGrape
  class GraphStore
    DEFAULT_PORT = 28282
    DEFAULT_URI = "druby://localhost:#{DEFAULT_PORT}"

    class << self
      def start(uri=nil, filename=nil, &block)
        self.new(filename).start uri, &block
      end

      def open(uri=nil)
        DRbObject.new_with_uri(uri || DEFAULT_URI)
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

    def graphs
      @graphs.keys.sort
    end

    def graph(key)
      self[key]
    end

    def put_graph(key, graph)
      self[key] = graph
    end

    def [](key)
      @graphs[key.to_sym]
    end

    def []=(key, graph)
      @graphs[key.to_sym] = graph
    end

    def start(uri=nil, &block)
      at_exit do
        File.open @filename, 'w' do |file|
          Marshal.dump @graphs, file
        end if @filename
      end

      uri = DEFAULT_URI if uri.nil? || uri == :default
      DRb.start_service uri, self
      block.call if block
      sleep
    end
  end
end
