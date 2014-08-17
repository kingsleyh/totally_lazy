require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Type Check' do

  it 'should raise UnsupportedTypeException exception if value is not of specified type' do
    expect(Type.check(1, Fixnum)).to eq(1)
    expect { Type.check('1', Fixnum) }.to raise_error(UnsupportedTypeException)
  end

  it 'should raise UnsupportedTypeException exception if value does not respond to specified method' do
     expect(Type.responds(1, :even?)).to eq(1)
     expect { Type.responds('1', :even?) }.to raise_error(UnsupportedTypeException)
  end

  it 'should raise UnsupportedTypeException exception if values do not respond to specified method' do
     expect(Type.responds_all(sequence(1,2,3), :to_s)).to eq([1,2,3])
     expect { Type.responds_all(sequence(1,2,3), :is_cool) }.to raise_error(UnsupportedTypeException)
   end

end