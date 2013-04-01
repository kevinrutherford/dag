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

end

