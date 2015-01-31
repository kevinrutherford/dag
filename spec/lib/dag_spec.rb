require 'spec_helper'

describe DAG do

  it 'when new' do
    expect(subject.vertices).to be_empty
    expect(subject.edges).to be_empty
  end

  context 'with one vertex' do
    it 'has only that vertex' do
      v = subject.add_vertex
      expect(subject.vertices).to eq([v])
    end

    it 'has no edges' do
      v = subject.add_vertex
      expect(v.outgoing_edges).to be_empty
      expect(v.incoming_edges).to be_empty
    end
  end

  context 'using a mix-in module' do
    subject { DAG.new(mixin: Thing) }
    let(:v) { subject.add_vertex(name: 'Fred') }

    module Thing
      def my_name
        payload[:name]
      end
    end

    it 'mixes the module into evey vertex' do
      expect((Thing === v)).to be_truthy
    end

    it 'allows the module to access the payload' do
      expect(v.my_name).to eq('Fred')
    end
  end

  context 'creating an edge' do
    let(:v1) { subject.add_vertex }

    context 'when valid' do
      let(:v2) { subject.add_vertex }
      let!(:e1) { subject.add_edge(origin: v1, destination: v2) }

      it 'leaves the origin vertex' do
        expect(v1.outgoing_edges).to eq([e1])
      end

      it 'arrives at the destination vertex' do
        expect(v2.incoming_edges).to eq([e1])
      end

      it 'adds no other edges' do
        expect(v1.incoming_edges).to be_empty
        expect(v2.outgoing_edges).to be_empty
      end

      it 'it has no properties' do
        expect(e1.properties).to be_empty
      end

      it 'allows multiple edges between a pair of vertices' do
        expect { subject.add_edge(origin: v1, destination: v2) }.to_not raise_error
      end

      it 'can specify properties' do
        e2 = subject.add_edge(origin: v1, destination: v2, properties: {foo: 'bar'})
        expect(e2.properties[:foo]).to eq('bar')
      end
    end

    context 'when invalid' do
      it 'requires an origin vertex' do
        expect { subject.add_edge(to: v1) }.to raise_error(ArgumentError)
      end

      it 'requires a destination vertex' do
        expect { subject.add_edge(from: v1) }.to raise_error(ArgumentError)
      end

      it 'requires the endpoints to be vertices' do
        expect { subject.add_edge(from: v1, to: 23) }.to raise_error(ArgumentError)
        expect { subject.add_edge(from: 45, to: v1) }.to raise_error(ArgumentError)
      end

      it 'requires the endpoints to be in the same DAG' do
        v2 = DAG.new.add_vertex
        expect { subject.add_edge(from: v1, to: v2) }.to raise_error(ArgumentError)
        expect { subject.add_edge(from: v2, to: v1) }.to raise_error(ArgumentError)
      end

      it 'rejects an edge that would create a loop' do
        v2 = subject.add_vertex
        v3 = subject.add_vertex
        v4 = subject.add_vertex
        subject.add_edge from: v1, to: v2
        subject.add_edge from: v2, to: v3
        subject.add_edge from: v3, to: v4
        expect { subject.add_edge from: v4, to: v1 }.to raise_error(ArgumentError)
      end

      it 'rejects an edge from a vertex to itself' do
        expect { subject.add_edge from: v1, to: v1 }.to raise_error(ArgumentError)
      end
    end

    context 'with different keywords' do
      let(:v1) { subject.add_vertex }
      let(:v2) { subject.add_vertex }
      let!(:e1) { subject.add_edge(origin: v1, destination: v2) }

      it 'allows :source and :sink' do
        expect(subject.add_edge(source: v1, sink: v2)).to eq(e1)
      end

      it 'allows :from and :to' do
        expect(subject.add_edge(from: v1, to: v2)).to eq(e1)
      end

      it 'allows :start and :end' do
        expect(subject.add_edge(start: v1, end: v2)).to eq(e1)
      end

    end

  end

  context 'given a dag' do
    subject { DAG.new(mixin: Thing) }
    module Thing
      def my_name
        payload[:name]
      end
    end

    let(:joe) { subject.add_vertex(name: "joe") }
    let(:bob) { subject.add_vertex(name: "bob") }
    let(:jane) { subject.add_vertex(name: "jane") }
    let!(:e1) { subject.add_edge(origin: joe, destination: bob, properties: {name: "father of"} ) }
    let!(:e2) { subject.add_edge(origin: joe, destination: jane) }
    let!(:e3) { subject.add_edge(origin: bob, destination: jane) }

    describe '.subgraph' do
      it 'returns a graph' do
        expect(subject.subgraph()).to be_an_instance_of(DAG)
      end

      it 'of joe and his ancestors' do
        subgraph = subject.subgraph([joe,],[])
        expect(subgraph.vertices.length).to eq(1)
        expect(subgraph.vertices[0].my_name).to eq("joe")
        expect(subgraph.edges).to be_empty
      end

      it 'of joe and his descendants' do
        subgraph = subject.subgraph([],[joe,])
        expect(Set.new(subgraph.vertices.map(&:my_name))).to eq(Set.new(["joe","bob","jane"]))
        expect(subgraph.edges.length).to eq(3)
      end

      it 'of Jane and her ancestors' do
        subgraph = subject.subgraph([jane,],[])
        expect(Set.new(subgraph.vertices.map(&:my_name))).to eq(Set.new(["joe","bob","jane"]))
        expect(subgraph.edges.length).to eq(3)
      end

      it 'of jane and her descendants' do
        subgraph = subject.subgraph([],[jane,])
        expect(Set.new(subgraph.vertices.map(&:my_name))).to eq(Set.new(["jane"]))
        expect(subgraph.edges).to be_empty
      end

      it 'of bob and his descendants' do
        subgraph = subject.subgraph([],[bob,])
        expect(Set.new(subgraph.vertices.map(&:my_name))).to eq(Set.new(["bob","jane"]))
        expect(subgraph.edges.length).to eq(1)
      end

      it 'there is something incestuous going on here' do
        subgraph = subject.subgraph([bob,],[bob,])
        expect(Set.new(subgraph.vertices.map(&:my_name))).to eq(Set.new(["bob","jane","joe"]))
        expect(subgraph.edges.length).to eq(2)
        expect(subgraph.edges[0].properties).to eq({name: "father of"})
        expect(subgraph.edges[1].properties).to eq({})
      end

    end

  end

end
