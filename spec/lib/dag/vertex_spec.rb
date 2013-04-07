require 'spec_helper'

describe DAG::Vertex do
  let(:dag) { DAG.new }
  subject { dag.add_vertex }
  let(:v1) { dag.add_vertex(name: :v1) }
  let(:v2) { dag.add_vertex(name: :v2) }

  describe 'an instance' do
    it 'cannot have a path to a non-vertex' do
      expect { subject.has_path_to?(23) }.to raise_error(ArgumentError)
    end

    it 'cannot have a path to a vertex in a different DAG' do
      expect { subject.has_path_to?(DAG.new.add_vertex) }.to raise_error(ArgumentError)
    end
  end

  describe 'with a payload' do
    subject { dag.add_vertex(name: 'Fred', size: 34) }

    it 'allows the payload to be accessed' do
      subject[:name].should == 'Fred'
      subject[:size].should == 34
      subject.payload.should == {name: 'Fred', size: 34}
    end

    it 'returns nil for missing payload key' do
      subject[56].should be_nil
    end

    it 'allows the payload to be changed' do
      subject.payload[:another] = 'ha'
      subject[:another].should == 'ha'
    end
  end

  context 'with predecessors' do
    before do
      dag.add_edge from: v1, to: subject
      dag.add_edge from: v2, to: subject
    end

    its(:predecessors) { should =~ [v1, v2] }
    its(:successors) { should == [] }

    it 'has no paths to its predecessors' do
      subject.has_path_to?(v1).should be_false
      subject.has_path_to?(v2).should be_false
    end

    context 'with multiple paths' do
      it 'lists each predecessor only once' do
        dag.add_edge from: v1, to: subject
        subject.predecessors.should == [v1, v2]
      end
    end
  end

  context 'with successors' do
    before do
      dag.add_edge from: subject, to: v1
      dag.add_edge from: subject, to: v2
    end

    its(:predecessors) { should == [] }
    its(:successors) { should =~ [v1, v2] }

    it 'has paths to its successors' do
      subject.has_path_to?(v1).should be_true
      subject.has_path_to?(v2).should be_true
    end

    context 'with multiple paths' do
      it 'lists each successor only once' do
        dag.add_edge from: subject, to: v1
        subject.successors.should == [v1, v2]
      end
    end
  end

  context 'in a deep DAG' do
    let(:v3) { dag.add_vertex }

    before do
      dag.add_edge from: subject, to: v1
      dag.add_edge from: v1, to: v2
    end

    it 'has a deep path to v2' do
      subject.has_path_to?(v2).should be_true
    end

    it 'has no path to v3' do
      subject.has_path_to?(v3).should be_false
    end
  end

end

