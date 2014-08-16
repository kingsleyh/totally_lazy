require 'rspec'
require_relative '../lib/totally_lazy'

describe 'Sequence' do

  it 'should create empty sequence when iterable is nil' do
    expect(sequence(nil)).to eq(empty)
  end

  it 'should support transpose' do
    expect(sequence(sequence(1, 2), sequence(3, 4), sequence(5, 6)).transpose).to include(sequence(1, 3, 5), sequence(2, 4, 6))
  end

  it 'should eagerly return the first element of a sequence, returns NoSuchElementException if empty' do
    expect(sequence(1, 2).head).to eq(1)
    expect { empty.head }.to raise_error(NoSuchElementException)
  end

  it 'should eagerly return the first element of a sequence wrapped in a some, returns none if empty' do
    expect(sequence(1, 2).head_option).to eq(some(1))
    expect(empty.head_option).to eq(none)
  end

  it 'should eagerly return the last element of a finite sequence, throws NoSuchElementException if empty' do
    expect(sequence(1, 2).last).to eq(2)
    expect { empty.last }.to raise_error(NoSuchElementException)
  end

  it 'should eagerly return the last element of a finite sequence wrapped in a some, returns none if empty' do
    expect(sequence(1, 2).last_option).to eq(some(2))
    expect(empty.last_option).to eq(none)
  end

  it 'should lazily return the elements except the last one - throws NoSuchElementException if empty. Works with infinite sequences' do
    expect(sequence(1, 2, 3).tail).to eq(sequence(2, 3))
    expect { empty.tail.first }.to raise_error(NoSuchElementException)
  end

  it 'should lazily return the elements except the first one - throws NoSuchElementException if empty' do
    expect(sequence(1, 2, 3).init).to eq(sequence(1, 2))
    expect { empty.init.first }.to raise_error(NoSuchElementException)
  end

  it 'should lazily shuffle the elements - throws NoSuchElementException if empty' do
    expect(sequence(1..50).shuffle.entries).not_to eq(sequence(1..50).entries)
    expect { empty.shuffle.first }.to raise_error(NoSuchElementException)
  end

  it 'should lazily join sequences together' do
    expect(sequence(1,2,3).join(sequence(4,5,6))).to eq(sequence(1,2,3,4,5,6))
    expect(empty.join(sequence(1,2))).to eq(sequence(1,2))
  end


end