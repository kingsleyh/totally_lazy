require 'rspec'
require_relative '../lib/totally_lazy'

describe 'Option' do

  it 'should support contains' do
    expect(option(1).contains(1)).to be(true)
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
    expect(option(1).join(sequence(2,3))).to eq(sequence(1,2,3))
  end

  it 'should get value of some' do

  end

  it 'should not get value of none' do

  end

  it 'should get or else' do

  end

  it 'should get or nil' do

  end

  it 'should get or raise exception' do

  end


end