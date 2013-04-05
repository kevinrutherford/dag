require_relative 'dag/vertex'

class DAG

  Edge = Struct.new(:origin, :destination)

  attr_reader :vertices, :edges

  def initialize
    @vertices = []
    @edges = []
  end

  def add_vertex
    Vertex.new(self).tap {|v| @vertices << v }
  end

  def add_edge(attrs)
    origin = attrs[:origin] || attrs[:source] || attrs[:from] || attrs[:start]
    destination = attrs[:destination] || attrs[:sink] || attrs[:to] || attrs[:end]
    raise ArgumentError.new('Origin must be a vertex in this DAG') unless
      origin && Vertex === origin && origin.dag == self
    raise ArgumentError.new('Destination must be a vertex in this DAG') unless
     destination && Vertex === destination && destination.dag == self
    Edge.new(origin, destination).tap {|e| @edges << e }
  end

end

