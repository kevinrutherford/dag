class DAG

  class Vertex
    attr_reader :dag

    def initialize(dag)
      @dag = dag
    end

    def outgoing_edges
      @dag.edges.select {|e| e.origin == self}
    end

    def incoming_edges
      @dag.edges.select {|e| e.destination == self}
    end

    def predecessors
      incoming_edges.map(&:origin)
    end

    def successors
      outgoing_edges.map(&:destination)
    end
  end

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

