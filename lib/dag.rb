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

  def subgraph(predecessors_of = [], successors_of = [])

    result = DAG.new({mixin: @mixin})
    vertex_mapping = {}
    edge_set = Set.new

    # Get the set of predecessors verticies and add a copy to the result
    predecessors_set = Set.new
    predecessors_of.each do |v|
      raise ArgumentError.new('You must supply a vertex in this DAG') unless
      v.kind_of?(Vertex) && v.dag == self
      predecessors_set.add(v)
      v.ancestors(predecessors_set)
    end

    predecessors_set.each do |v|
      vertex_mapping[v] = result.add_vertex(payload=v.payload)
    end

  # Get the set of successor vertices and add a copy to the result
    successors_set = Set.new
    successors_of.each do |v|
      raise ArgumentError.new('You must supply a vertex in this DAG') unless
      v.kind_of?(Vertex) && v.dag == self
      successors_set.add(v)
      v.descendants(successors_set)
    end

    successors_set.each do |v|
      vertex_mapping[v] = result.add_vertex(payload=v.payload) unless vertex_mapping.include? v
    end

    # add all the edges of the predecessors
    predecessors_set.each do |destination|
      destination.incoming_edges.each do |e|
        unless edge_set.include? e
          origin = e.origin
          result.add_edge(
            from: vertex_mapping[origin],
            to: vertex_mapping[destination])
        end
      end
    end

    # add all the edges of the successors
    successors_set.each do |origin|
      origin.outgoing_edges.each do |e|
        unless edge_set.include? e
          destination = e.destination
          result.add_edge(
            from: vertex_mapping[origin],
            to: vertex_mapping[destination])
        end
      end
    end

    return result
  end


end

