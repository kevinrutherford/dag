require 'spec_helper'

describe DAG::Vertex do
  let(:dag) { DAG.new }
  subject { dag.add_vertex }
  let(:v1) { dag.add_vertex }
  let(:v2) { dag.add_vertex }

  context 'with predecessors' do
    before do
      dag.add_edge from: v1, to: subject
      dag.add_edge from: v2, to: subject
    end

    its(:predecessors) { should =~ [v1, v2] }
    its(:successors) { should == [] }
  end

  context 'with successors' do
    before do
      dag.add_edge from: subject, to: v1
      dag.add_edge from: subject, to: v2
    end

    its(:predecessors) { should == [] }
    its(:successors) { should =~ [v1, v2] }
  end

end

