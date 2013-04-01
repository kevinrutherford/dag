class DAG

  class Vertex
    def initialize(dag)
      @dag = dag
    end

    def outgoing_edges
      @dag.edges.select {|e| e.origin == self}
    end

    def incoming_edges
      @dag.edges.select {|e| e.destination == self}
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
    origin = attrs[:origin] || attrs[:source] || attrs[:from]
    destination = attrs[:destination] || attrs[:sink] || attrs[:to]
    Edge.new(origin, destination).tap {|e| @edges << e }
  end

end

