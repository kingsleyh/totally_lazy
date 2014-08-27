require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Predicates' do

  it 'should return only even numbers' do
    expect(sequence(1,2,3,4,5,6).filter(even)).to eq(sequence(2,4,6))
    expect(sequence(1,2,3,4,5,6).unfilter(odd)).to eq(sequence(2,4,6))
    expect { sequence(pair(1,2),pair(3,4)).filter(even).entries }.to raise_error(UnsupportedTypeException)
  end

  it 'should return only odd numbers' do
    expect(sequence(1,2,3,4,5,6).filter(odd)).to eq(sequence(1,3,5))
    expect(sequence(1,2,3,4,5,6).unfilter(even)).to eq(sequence(1,3,5))
    expect { sequence(pair(1,2),pair(3,4)).filter(odd).entries }.to raise_error(UnsupportedTypeException)
  end

  it 'should return content as string' do
    expect(sequence(1,2).map(as_string)).to eq(sequence("1","2"))
    expect(sequence(pair(1,2),pair(3,4)).map(as_string).entries).to eq([{'1'=>'2'},{'3'=>'4'}])
  end

  it 'should return content as int' do
    expect(sequence('1','2').map(as_int)).to eq(sequence(1,2))
    expect(sequence(pair('1','2'),pair('3','4')).map(as_int).entries).to eq([{1=>2}, {3=>4}])
  end

  it 'should return content as float' do
    expect(sequence(1,2).map(as_float)).to eq(sequence(1.0,2.0))
    expect(sequence(pair(1,2),pair(3,4)).map(as_float).entries).to eq([{1.0=>2.0}, {3.0=>4.0}])
  end

  it 'should return content as array' do
    expect(sequence(1,2).map(as_array)).to eq(sequence([1],[2]))
    expect(sequence(pair(1,2),pair(3,4)).map(as_array).head.class).to eq(Array)
  end

  it 'should work with basic where predicates' do
    expect(sequence(1,2,3).filter(where(is greater_than 1))).to eq(sequence(2,3))
    expect(sequence(1,2,3).filter(where(is greater_than 1).and(is less_than 3))).to eq(sequence(2))
  end

  it 'should work with method where predicates' do
    expect(sequence(pair(1,2),pair(3,4),pair(5,7)).filter(where(key:greater_than(1)).and(value:odd)).to_a).to eq(sequence(pair(5,7)).to_a)
  end

  it 'should work with inverted value predicates' do
    expect(sequence(1,2,3,4,5).reject(where(is Compare.equal_to 3))).to eq(sequence(1,2,4,5))
    expect(sequence(pair(1,2),pair(3,4),pair(5,7)).reject(where value:odd).to_a).to eq(sequence(pair(1,2),pair(3,4)).to_a)
    expect(sequence(pair(1,2),pair(3,4),pair(5,7)).reject(where value:equals(2)).to_a).to eq(sequence(pair(3,4),pair(5,7)).to_a)
  end

  it 'should work with inverted predicates' do
    expect(sequence(1,2,3,4,5).reject(where(is odd))).to eq(sequence(2,4))
    expect(sequence(1,2,3,4,5).reject(odd)).to eq(sequence(2,4))
    expect(sequence(1,2,3,4,5).reject(greater_than 2)).to eq(sequence(1,2))
    expect(sequence(1,2,3,4,5).filter(greater_than 2)).to eq(sequence(3,4,5))
  end


end
