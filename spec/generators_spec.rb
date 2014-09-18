require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Generators' do

  it 'should support repeat' do
    expect(Seq.repeat('car').take(2)).to eq(sequence('car', 'car'))
    expect(Iter.repeat('car').take(2).entries).to eq(%w(car car))
  end

  it 'should support range' do
    expect(Seq.range(1, 4)).to eq(sequence(1, 2, 3, 4))
    expect(Iter.range(1, 4).entries).to eq([1, 2, 3, 4])
  end

  it 'should support iterate' do
    expect(Seq.iterate(:+, 1).take(4)).to eq(sequence(1, 2, 3, 4))
    expect(Iter.iterate(:+, 1).take(4).entries).to eq([1, 2, 3, 4])
    expect(Seq.iterate(:+, 1, 5).take(4)).to eq(sequence(5, 6, 7, 8))
    expect(Iter.iterate(:+, 1, 5).take(4).entries).to eq([5, 6, 7, 8])
  end

  it 'should support primes' do
    expect(Seq.primes.take(3)).to eq(sequence(2, 3, 5))
    expect(Iter.primes.take(3).entries).to eq([2, 3, 5])
  end

  it 'should support fibonacci' do
    expect(Seq.fibonacci.take(3)).to eq(sequence(1, 1, 2))
    expect(Iter.fibonacci.take(3).entries).to eq([1, 1, 2])
  end

  it 'should support powers_of' do
    expect(Seq.range(1, 4)).to eq(sequence(1, 2, 3, 4))
    expect(Iter.range(1, 4).entries).to eq([1, 2, 3, 4])
  end

end