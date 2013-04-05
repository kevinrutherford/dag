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
      incoming_edges.map(&:origin).uniq
    end

    def successors
      outgoing_edges.map(&:destination).uniq
    end

    def has_path_to?(other)
      raise ArgumentError.new('You must supply a vertex in this DAG') unless
        other && Vertex === other && other.dag == self.dag
      successors.include?(other) || successors.any? {|v| v.has_path_to?(other) }
    end
  end

end

