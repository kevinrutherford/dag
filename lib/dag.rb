class DAG

  class Vertex
    def outgoing_edges
      []
    end

    def incoming_edges
      []
    end
  end

  def vertices
    @vertices ||= []
  end

  def add_vertex
    Vertex.new.tap {|v| vertices << v }
  end

end

