require_relative 'dag/vertex'

class DAG

  Edge = Struct.new(:origin, :destination, :properties)

  attr_reader :vertices, :edges

  #
  # Create a new Directed Acyclic Graph
  #
  # @param [Hash] options configuration options
  # @option options [Module] mix this module into any created +Vertex+
  #
  def initialize(options = {})
    @vertices = []
    @edges = []
    @mixin = options[:mixin]
  end

  def add_vertex(payload = {})
    Vertex.new(self, payload).tap {|v|
      v.extend(@mixin) if @mixin
      @vertices << v
    }
  end

  def add_edge(attrs)
    origin = attrs[:origin] || attrs[:source] || attrs[:from] || attrs[:start]
    destination = attrs[:destination] || attrs[:sink] || attrs[:to] || attrs[:end]
    properties = attrs[:properties] || {}
    raise ArgumentError.new('Origin must be a vertex in this DAG') unless
      origin && Vertex === origin && origin.dag == self
    raise ArgumentError.new('Destination must be a vertex in this DAG') unless
     destination && Vertex === destination && destination.dag == self
    raise ArgumentError.new('A DAG must not have cycles') if origin == destination
    raise ArgumentError.new('A DAG must not have cycles') if destination.has_path_to?(origin)
    Edge.new(origin, destination, properties).tap {|e| @edges << e }
  end

end

