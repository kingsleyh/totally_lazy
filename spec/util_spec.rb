require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Maps' do

  it 'should return a sequence of maps as a merged map' do
    expect(Maps.merge(sequence(:a,2,:b,4).to_maps)).to eq({a:2,b:4})
    expect(Maps.merge(sequence(1,2,3,4).to_maps(false))).to eq({1=>2,3=>4})
  end

end