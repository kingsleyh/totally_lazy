require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Pair' do

  it 'should return the first item: first/key' do
    expect(pair(1, 2).first).to eq(1)
    expect(pair(1, 2).key).to eq(1)
  end

  it 'should return the second item: second/value' do
    expect(pair(1, 2).second).to eq(2)
    expect(pair(1, 2).value).to eq(2)
  end

  it 'should return sequence of values' do
    expect(pair(1, 2).values).to eq(sequence(1, 2))
  end

  it 'should convert to string' do
    expect(pair('apples', 2).to_s).to eq({'apples' => '2'})
  end

  it 'should convert to a sequence of pairs from a map' do
    expect(Pair.from_map({apples: '10'}).to_a).to eq(sequence(pair(:apples, '10')).to_a)
  end

  it 'should convert a pair to a map' do
    expect(pair(1, 2).to_map).to eq({1 => 2})
  end

  it 'should convert to int' do
    expect(pair('1', '2').to_i).to eq({1 => 2})
  end

  it 'should convert to float' do
    expect(pair('1', '2').to_f).to eq({1.0 => 2.0})
  end

  it 'should support each' do
    expect(pair(1,2).each{|x| x }).to eq([1,2])
  end

end