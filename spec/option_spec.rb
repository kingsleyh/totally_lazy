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

  it 'should return boolean for empty?' do
    expect(option(1).empty?).to eq(false)
    expect(option(empty).empty?).to eq(true)
  end

  it 'should return boolean for defined?' do
    expect(option(1).defined?).to eq(true)
    expect(option('').defined?).to eq(false)
  end

  it 'should convert to sequence' do
    expect(option(1).to_seq).to eq(sequence(option(1)))
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

  it 'should return sequence for none' do
    expect(option(empty).to_seq).to eq(sequence(none))
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



end