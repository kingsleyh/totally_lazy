require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Option' do

  it 'should support contains' do
    expect(option(1).contains(1)).to eq(true)
  end

  it 'should support is alias' do
    pending('support is alias')
    pass
  end

  it 'should support exists' do
    pending('exists')
    pass
  end

  it 'should support join' do
    expect(option(1).join(sequence(2, 3))).to eq(sequence(1, 2, 3))
  end

  it 'should get value of some' do
    expect(option(1).get).to eq(1)
  end

  it 'should not get value of none' do
    pending('not get none')
    pass
  end

  it 'should get or else' do
    expect(option(1).get_or_else(2)).to eq(1)
    expect(option(empty).get_or_else(2)).to eq(2)
  end

  it 'should get or nil' do
    expect(option(1).get_or_nil).to eq(1)
    expect(option(empty).get_or_nil).to eq(nil)
  end

  it 'should get or raise exception' do
    expect(option(1).get_or_throw(Exception)).to eq(1)
    expect { option(empty).get_or_throw(Exception) }.to raise_error(Exception)
  end


end