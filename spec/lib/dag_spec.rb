require 'spec_helper'

describe DAG do

  it 'starts with no vertices' do
    DAG.new.vertices.should == []
  end

end

