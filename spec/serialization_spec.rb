require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Sequence Serialization/Deserialization' do

  it 'should serialize a sequence' do
    serialized = sequence(pair(7, 8), sequence(1, 2), sequence(3, sequence(5, 6)), sequence(pair(:apple, 99), option(1), none), [10, 11], {:apple => 8, :pear => 9}).serialize
    expect(serialized).to eq([{:type => :pair, :values => {7 => 8}}, {:type => :sequence, :values => [1, 2]}, {:type => :sequence, :values => [3, {:type => :sequence, :values => [5, 6]}]}, {:type => :sequence, :values => [{:type => :pair, :values => {:apple => 99}}, {:type => :some, :values => 1}, {:type => :none, :values => nil}]}, {:type => Array, :values => [10, 11]}, {:type => Hash, :values => [{:type => Array, :values => [:apple, 8]}, {:type => Array, :values => [:pear, 9]}]}])
  end

  it 'should deserialize a serialized sequence containing pair' do
    expect(seq[0].to_map).to eq(pair(7, 8).to_map)
  end

  it 'should deserialize a serialized sequence containing sequence' do
    expect(seq[1]).to eq(sequence(1, 2))
  end

  it 'should deserialize a serialized sequence containing nested sequence' do
    expect(seq[2]).to eq(sequence(3, sequence(5, 6)))
  end

  it 'should deserialize a serialized sequence containing some' do
    expect(seq[3][1]).to eq(option(1))
  end

  it 'should deserialize a serialized sequence containing none' do
    expect(seq[3][2]).to eq(none)
  end

  it 'should deserialize a serialized sequence containing an array' do
    expect(seq[4]).to eq([10,11])
  end

  it 'should deserialize a serialized sequence containing a hash' do
    expect(seq[5]).to eq({:apple => 8, :pear => 9})
  end

  private

  def seq
    serialized = sequence(pair(7, 8), sequence(1, 2), sequence(3, sequence(5, 6)), sequence(pair(:apple, 99), option(1), none), [10, 11], {:apple => 8, :pear => 9}).serialize
    deserialize(serialized)
  end

end