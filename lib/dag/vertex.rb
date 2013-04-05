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

end

