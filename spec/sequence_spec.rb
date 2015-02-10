require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Sequence' do

  it 'should create empty sequence when iterable is nil' do
    expect(sequence(nil)).to eq(empty)
  end

  it 'should support transpose' do
    expect(sequence(sequence(1, 2), sequence(3, 4), sequence(5, 6)).transpose).to include(sequence(1, 3, 5), sequence(2, 4, 6))
    expect { empty.transpose.entries }.to raise_error(NoSuchElementException)
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
    expect(sequence(1, 2, 3).join(sequence(4, 5, 6))).to eq(sequence(1, 2, 3, 4, 5, 6))
    expect(empty.join(sequence(1, 2))).to eq(sequence(1, 2))
  end

  it 'should support select' do
    expect(sequence(1, 2, 3).filter(even)).to eq(sequence(2))
    expect(sequence(1, 2, 3).find_all(even)).to eq(sequence(2))
    expect(sequence(1, 2, 3).select(even)).to eq(sequence(2))
    expect(sequence(1, 2, 3).filter(&:even?)).to eq(sequence(2))
  end

  it 'should support map' do
    expect(sequence(1, 2, 3).map(as_string)).to eq(sequence('1', '2', '3'))
    expect(sequence(1, 2, 3).collect(as_string)).to eq(sequence('1', '2', '3'))
    expect(sequence(1, 2, 3).map { |x| x.to_s }).to eq(sequence('1', '2', '3'))
  end

  it 'should support reject' do
    expect(sequence(1, 2, 3).reject(even)).to eq(sequence(1, 3))
    expect(sequence(1, 2, 3).unfilter(even)).to eq(sequence(1, 3))
    expect(sequence(1, 2, 3).reject(&:even?)).to eq(sequence(1, 3))
  end

  it 'should support grep' do
    expect(sequence('apple', 'pear', 'banana').grep(/p/)).to eq(sequence('apple', 'pear'))
  end

  it 'should support drop' do
    expect(sequence(1, 2, 3).drop(1)).to eq(sequence(2, 3))
  end

  it 'should support drop_while' do
    expect(sequence(1, 2, 5, 4, 3).drop_while { |n| n < 5 }).to eq(sequence(5, 4, 3))
  end

  it 'should support take' do
    expect(sequence(1, 2, 3).take(2)).to eq(sequence(1, 2))
  end

  it 'should support take_while' do
    expect(sequence(1, 2, 5, 4, 3).take_while { |n| n < 5 }).to eq(sequence(1, 2))
  end

  it 'should support flat_map' do
    expect(sequence(sequence(1, 2), sequence(3, 4)).flat_map { |s| s }).to eq(sequence(1, 2, 3, 4))
    expect(sequence(pair(1, 2), pair(3, 4)).flat_map { |s| s }).to eq(sequence(1, 2, 3, 4))
  end

  it 'should support zip' do
    expect(sequence(1, 2, 3).zip(sequence('a', 'b', 'c'))).to eq(sequence([1, 'a'], [2, 'b'], [3, 'c']))
    expect(sequence(1, 2, 3).zip(sequence(4, 5, 6)) { |x| x.reduce(:+) }).to eq(sequence(5, 7, 9))
  end

  it 'should support item access with get' do
    expect(sequence(1, 2, 3).get(2)).to eq(3)
    expect(sequence(1, 2, 3)[2]).to eq(3)
  end

  it 'should join the supplied sequence to the existing sequence' do
    expect(sequence(1, 2, 3).join(sequence(4, 5, 6))).to eq(sequence(1, 2, 3, 4, 5, 6))
    expect(sequence(1, 2, 3) << sequence(4, 5, 6)).to eq(sequence(1, 2, 3, 4, 5, 6))
  end

  it 'should append an item to the sequence (creates new sequence)' do
    expect(sequence(1, 2, 3).append(4)).to eq(sequence(1, 2, 3, 4))
  end

  it 'should add any item to the sequence (creates new sequence)' do
    expect(sequence(1, 2, 3).add(sequence(4, 5, 6))).to eq(sequence(1, 2, 3, 4, 5, 6))
    expect(sequence(1, 2, 3) + sequence(4, 5, 6)).to eq(sequence(1, 2, 3, 4, 5, 6))
  end

  it 'should convert a sequence of sequences into a single flattened sequence' do
    expect(sequence(sequence(1,2,3), sequence(4), sequence(5,6,7)).to_seq).to eq(sequence(1, 2, 3, 4, 5, 6,7))
    expect{ sequence(1,2,3).to_seq.entries }.to raise_error(UnsupportedTypeException)
  end

  it 'should create a sequence of sequences from a sequence of pairs' do
    expect(sequence(pair(1,2),pair(3,4),pair(5,6)).from_pairs).to eq(sequence(1, 2, 3, 4, 5, 6))
    expect {sequence({1=>2}).from_pairs.entries}.to raise_error(UnsupportedTypeException)
  end

  it 'should convert a sequence to an array' do
    expect(sequence(1, 2, 3).to_a).to eq([1,2,3])
    expect(sequence(pair(1,2),pair(3,4)).to_a).to eq([{1=>2},{3=>4}])
    expect(empty.to_a).to eq([])
  end

  it 'should get or else the value at an index' do
    expect(sequence(1, 2, 3).get_or_else(0,99)).to eq(1)
    expect(sequence(1, 2, 3).get_or_else(99,1)).to eq(1)
  end

  it 'should get or else the value at an index' do
     expect(sequence(1, 2, 3).get_or_throw(1,Exception,'oops')).to eq(2)
     expect {sequence(1, 2, 3).get_or_throw(99,Exception,'oops')}.to raise_error(Exception)
   end

  it 'should get an option at an index' do
    expect(sequence(1, 2, 3).get_option(1)).to eq(some(2))
    expect(sequence(1, 2, 3).get_option(99)).to eq(none)
  end

  it 'should return all as flattened array' do
    expect(sequence(sequence(1, 2, 3),sequence(4,5,6)).all).to eq([1,2,3,4,5,6])
  end

  it 'should iterate empty' do
    expect(empty.each{|i| i}).to eq([])
    expect(Empty.new([1,2]).each{|i| i}).to eq([1,2])
    expect(Empty.new([1,2]){|a| a}).to eq(empty)
  end

  it 'should support from_arrays' do
    expect(sequence([1,2,3,4,5],[6,7]).from_arrays).to eq(sequence(1,2,3,4,5,6,7))
  end

  it 'should support from_sets' do
    expect(sequence(Set.new([1,2,3,4,5]),Set.new([6,7])).from_sets.entries).to eq(sequence(1,2,3,4,5,6,7).entries)
  end

  it 'should map concurrently' do
    expect(sequence(1,2,3,4,5).map_concurrently(even)).to eq(sequence(2,4))
    expect(sequence(1,2,3,4,5).map_concurrently{|i| i+1}).to eq(sequence(2,3,4,5,6))
    expect(sequence(1,2,3,4,5).map_concurrently(even,in_threads:2)).to eq(sequence(2,4))
    expect(sequence(1,2,3,4,5).map_concurrently(where(is even),in_processes:2)).to eq(sequence(2,4))
    expect(sequence(1,2,3,4,5).map_concurrently(nil,in_threads:2){|i| i+1}).to eq(sequence(2,3,4,5,6))
  end

  it 'should each concurrently' do
    expect(sequence(1,2,3).each_concurrently{|i| i }).to eq([1,2,3])
  end

  it 'should drop nils' do
    expect(sequence(1,nil,2,nil,3).drop_nil).to eq(sequence(1,2,3))
  end

  it 'should cycle' do
    expect(sequence(1,2,3).cycle.take(6)).to eq(sequence(1,2,3,1,2,3))
  end

  it 'should get pairs from sequence' do
    expect(sequence(:name,'kings',:age,39).in_pairs.to_a).to eq(sequence(pair(:name,'kings'),pair(:age,39)).to_a)
  end

  it 'should update items in a sequence' do
    expect(Seq.repeat(->{OpenStruct.new(name:Any.string(5),age:Any.int(2))}).take(100000).update(age:11,name:'woops').take(10).map{|s| [s.name,s.age]}.head).to eq(['woops',11])
    expect(Seq.range(1,10).filter(odd).update(2)).to eq(sequence(2,2,2,2,2))
  end

  it 'should sort by attributes' do
    expect(sequence(pair(:a,1),pair(:d,4),pair(:c,3),pair(:b,2)).sorting_by{|e| e.value }.to_a).to eq([{:a=>1}, {:b=>2}, {:c=>3}, {:d=>4}])
    expect(sequence(pair(:a,1),pair(:d,4),pair(:c,3),pair(:b,2)).sorting_by(:value).to_a).to eq([{:a=>1}, {:b=>2}, {:c=>3}, {:d=>4}])
    expect(sequence(
        OpenStruct.new(first_name:'David',age:19,job:'computers'),
        OpenStruct.new(first_name:'Chris',age:19,job:'art'),
        OpenStruct.new(first_name:'Andrew',age:32,job:'dancing'),
        OpenStruct.new(first_name:'Andrew',age:18,job:'dancing'),
           ).sorting_by{|e| [e.first_name,e.age] }.map{|e| [e.first_name,e.age,e.job]}.to_a).to eq([['Andrew', 18, 'dancing'], ['Andrew', 32, 'dancing'], ['Chris', 19, 'art'], ['David', 19, 'computers']])
  end

  it 'should sort' do
    expect(sequence(5,2,3,1,4).sorting).to eq(sequence(1,2,3,4,5))
  end

  it 'should convert sequence to a map' do
    expect(sequence(oops('apple',1,'pear',2)).to_map).to eq({apple:1,pear:2})
  end

  def oops(*values)
    values
  end



end