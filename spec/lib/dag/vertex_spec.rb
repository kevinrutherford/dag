require 'spec_helper'

describe DAG::Vertex do
  let(:dag) { DAG.new }
  subject { dag.add_vertex }
  let(:v1) { dag.add_vertex(name: :v1) }
  let(:v2) { dag.add_vertex(name: :v2) }
  let(:v3) { dag.add_vertex(name: 'v3') }

  describe '#has_path_to?' do
    it 'cannot have a path to a non-vertex' do
      expect { subject.has_path_to?(23) }.to raise_error(ArgumentError)
    end

    it 'cannot have a path to a vertex in a different DAG' do
      expect { subject.has_path_to?(DAG.new.add_vertex) }.to raise_error(ArgumentError)
    end
  end

  describe '#has_ancestor?' do
    it 'ancestors must be a vertex' do
      expect { subject.has_ancestor?(23) }.to raise_error(ArgumentError)
    end

    it 'ancestors must be in the same DAG' do
      expect { subject.has_ancestor?(DAG.new.add_vertex) }.to raise_error(ArgumentError)
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

    it 'has the correct ancestors' do
      subject.has_ancestor?(v1).should be_true
      subject.has_ancestor?(v2).should be_true
      subject.has_ancestor?(v3).should be_false
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

    it 'has no ancestors' do
      subject.has_ancestor?(v1).should be_false
      subject.has_ancestor?(v2).should be_false
    end
  end

  context 'in a deep DAG' do
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

    it 'recognises that it is an ancestor of v2' do
      v2.has_ancestor?(subject).should be_true
    end

    it 'is known to all descendants' do
      v2.ancestors.should == Set.new([v1, subject])
    end

    it 'knows has no ancestors' do
      subject.ancestors.should == Set.new()
    end

    it 'knows has all descendants' do
      subject.descendants.should == Set.new([v1, v2])
    end

  end

end

