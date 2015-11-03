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

  it 'should support each' do
    result = []
    option(sequence(1,2,3)).each{|i| result << i+1}
    expect(result).to eq([2,3,4])
    result = []
    option(none).each{|i| result << i+1}
    expect(result).to eq([])
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

  it 'should return boolean for empty?' do
    expect(option(1).empty?).to eq(false)
    expect(option(empty).empty?).to eq(true)
  end

  it 'should return boolean for defined?' do
    expect(option(1).defined?).to eq(true)
    expect(option('').defined?).to eq(false)
  end

  it 'should convert to sequence' do
    expect(option(1).to_seq).to eq(sequence(1))
    expect(none.to_seq).to eq(empty)
  end

  it 'should raise empty exception when calling get on none' do
    expect { option(empty).get }.to raise_error(NoSuchElementException)
  end

  it 'should raise empty exception when calling value on none' do
    expect { option(empty).value }.to raise_error(NoSuchElementException)
  end

  it 'should return true for empty on none' do
    expect(option(empty).empty?).to eq(true)
  end

  it 'should return false for defined on none' do
    expect(option(empty).defined?).to eq(false)
  end

  it 'should return the else in get_or_else for none' do
    expect(option(empty).get_or_else(1)).to eq(1)
  end

  it 'should return nil in get_or_nil for none' do
    expect(option(empty).get_or_nil).to eq(nil)
  end

  it 'should raise exception in get_or_throw for none' do
    expect { option(empty).get_or_throw(Exception, 'oops') }.to raise_error(Exception)
  end

  it 'should return false for contains for none' do
     expect(option(empty).contains('ooo')).to eq(false)
  end

  it 'should return false for exists for none' do
    pending('needs work')
    pass
  end

  it 'should return false for contains for none' do
     expect(option(empty).contains('ooo')).to eq(false)
  end

  it 'should return original sequence for join on none' do
    expect(option(empty).join(sequence(1,2))).to eq(sequence(1,2))
    expect(option(empty).join([1,2])).to eq(sequence([1,2]))
  end

  it 'should know the type' do
    expect(option(empty).is_none?).to be(true)
    expect(option(empty).is_some?).to be(false)
    expect(option(1).is_none?).to be(false)
    expect(option(1).is_some?).to be(true)
  end

  it 'should support select' do
    expect(option(2).filter(even)).to eq(some(2))
    expect(option(2).find_all(even)).to eq(some(2))
    expect(option(2).select(even)).to eq(some(2))
    expect(option(2).filter(&:even?)).to eq(some(2))
    expect(option(2).filter{|v| v == 2}).to eq(some(2))
    expect(option(nil).filter(even)).to eq(none)
  end

  it 'should support map' do
    expect(option([{apple:1,pear:2},{melon:3}]).map{|h| h}).to eq(some([{apple:1,pear:2},{melon:3}]))
    expect(option({apple:1,pear:2})).to eq(some({apple:1,pear:2}))
    expect(option(1).map(as_string)).to eq(some('1'))
    expect(option(1).collect(as_string)).to eq(some('1'))
    expect(option(sequence(1, 2, 3)).map { |s| s.entries }).to eq(some([1, 2, 3]))
    expect(option(nil).map(as_string)).to eq(none)
  end

  it 'should support reject' do
    expect(option(2).reject(odd)).to eq(some(2))
    expect(option(2).unfilter(odd)).to eq(some(2))
    expect(option(2).reject(&:odd?)).to eq(some(2))
    expect(option(2).reject{|v| v == 1}).to eq(some(2))
    expect(option(nil).reject(odd)).to eq(none)
  end

  it 'should support grep' do
    expect(option('apple').grep(/p/)).to eq(some('apple'))
    expect(option(nil).grep(/p/)).to eq(none)
  end

  it 'should support drop' do
    expect(option(1).drop(1)).to eq(none)
    expect(option(nil).drop(1)).to eq(none)
  end

  it 'should support drop_while' do
    expect(option(sequence(1,7)).drop_while { |n| n < 5 }).to eq(some(1))
    expect(option(nil).drop_while { |n| n < 5 }).to eq(none)
  end

  it 'should support take' do
    expect(option(1).take(2)).to eq(some(1))
    expect(option(nil).take(2)).to eq(none)
  end

  it 'should support take_while' do
    expect(option(sequence(1,7)).take_while { |n| n < 5 }).to eq(some(1))
    expect(option(nil).take_while { |n| n < 5 }).to eq(none)
  end

  it 'should support flat_map' do
    expect(option(nil).flat_map{|v| v.first}).to eq(none)
  end

end
