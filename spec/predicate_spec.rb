require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Predicates' do

  it 'should return only even numbers' do
    expect(sequence(1,2,3,4,5,6).filter(even)).to eq(sequence(2,4,6))
    expect { sequence(pair(1,2),pair(3,4)).filter(even).entries }.to raise_error(UnsupportedTypeException)
  end

  it 'should return only even numbers' do
    expect(sequence(1,2,3,4,5,6).filter(even)).to eq(sequence(2,4,6))
    expect { sequence(pair(1,2),pair(3,4)).filter(even).entries }.to raise_error(UnsupportedTypeException)
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


end
