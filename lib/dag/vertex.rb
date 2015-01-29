class DAG

  class Vertex
    attr_reader :dag, :payload

    def initialize(dag, payload)
      @dag = dag
      @payload = payload
    end

    private :initialize

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

    def inspect
      "DAG::Vertex:#{@payload.inspect}"
    end

    #
    # Is there a path from here to +other+ following edges in the DAG?
    #
    # @param [DAG::Vertex] another Vertex is the same DAG
    # @raise [ArgumentError] if +other+ is not a Vertex in the same DAG
    # @return true iff there is a path following edges within this DAG
    #
    def has_path_to?(other)
      raise ArgumentError.new('You must supply a vertex in this DAG') unless
        other && Vertex === other && other.dag == self.dag
      successors.include?(other) || successors.any? {|v| v.has_path_to?(other) }
    end

    alias :has_descendent? :has_path_to?

    #
    # Is there a path from +other+ to here following edges in the DAG?
    #
    # @param [DAG::Vertex] another Vertex is the same DAG
    # @raise [ArgumentError] if +other+ is not a Vertex in the same DAG
    # @return true iff there is a path following edges within this DAG
    #
    def has_ancestor?(other)
      raise ArgumentError.new('You must supply a vertex in this DAG') unless
        other && Vertex === other && other.dag == self.dag
      predecessors.include?(other) || predecessors.any? {|v| v.has_ancestor?(other) }
    end

    alias :is_reachable_from? :has_ancestor?

    #
    # Retrieve a value from the vertex's payload.
    # This is a shortcut for vertex.payload[key].
    #
    # @param key [Object] the payload key
    # @return the corresponding value from the payload Hash, or nil if not found
    #
    def [](key)
      @payload[key]
    end

    def ancestors(result_set = Set.new)
      predecessors.each do |v|
        unless result_set.include? v
          result_set.add(v)
          v.ancestors(result_set)
        end
      end
      return result_set
    end

    def descendants(result_set = Set.new)
      successors.each do |v|
        unless result_set.include? v
          result_set.add(v)
          v.descendants(result_set)
        end
      end
      return result_set
    end

  end

end

