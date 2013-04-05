require 'spec_helper'

describe DAG do

  context 'when new' do
    it 'starts with no vertices' do
      subject.vertices.should be_empty
    end
  end

  context 'with one vertex' do
    it 'has only that vertex' do
      v = subject.add_vertex
      subject.vertices.should == [v]
    end

    it 'has no edges' do
      v = subject.add_vertex
      v.outgoing_edges.should be_empty
      v.incoming_edges.should be_empty
    end
  end

  context 'creating an edge' do
    context 'when valid' do
      let(:v1) { subject.add_vertex }
      let(:v2) { subject.add_vertex }
      let!(:e1) { subject.add_edge(origin: v1, destination: v2) }

      it 'leaves the origin vertex' do
        v1.outgoing_edges.should == [e1]
      end

      it 'arrives at the destination vertex' do
        v2.incoming_edges.should == [e1]
      end

      it 'adds no other edges' do
        v1.incoming_edges.should be_empty
        v2.outgoing_edges.should be_empty
      end
    end

    context 'between two different DAGs' do
      let(:v1) { subject.add_vertex }
      let(:v2) { DAG.new.add_vertex }

      it 'raises an error' do
        expect { subject.add_edge(from: v1, to: v2) }.to raise_error(ArgumentError)
      end
    end

    context 'when no start is supplied' do
      let(:v2) { subject.add_vertex }

      it 'raises an error' do
        expect { subject.add_edge(to: v2) }.to raise_error(ArgumentError)
      end
    end

    context 'when no end is supplied' do
      let(:v1) { subject.add_vertex }

      it 'raises an error' do
        expect { subject.add_edge(from: v1) }.to raise_error(ArgumentError)
      end
    end

    context 'when one endpoint is not a vertex' do
      let(:v1) { subject.add_vertex }

      it 'raises an error' do
        expect { subject.add_edge(from: v1, to: 23) }.to raise_error(ArgumentError)
      end
    end

    context 'when the edge would cause a cycle to exist' do
      it 'raises an error'
    end

    context 'with different keywords' do
      let(:v1) { subject.add_vertex }
      let(:v2) { subject.add_vertex }
      let!(:e1) { subject.add_edge(origin: v1, destination: v2) }

      it 'allows source and sink' do
        subject.add_edge(source: v1, sink: v2).should == e1
      end

      it 'allows from and to' do
        subject.add_edge(from: v1, to: v2).should == e1
      end

      it 'allows start and end' do
        subject.add_edge(start: v1, end: v2).should == e1
      end

    end

  end

  context 'vertex attributes'

  context 'edge attributes'

end

