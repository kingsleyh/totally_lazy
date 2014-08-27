require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Functor' do

    it 'should create a new functor' do
      fc = Functor.new do |op, *a, &b|
        [op, a, b]
      end
      expect(fc+1).to eq([:+, [1], nil])
    end

    it 'should support class method' do
      fc = Functor.new do |op, *a, &b|
        [op, a, b]
      end
      expect( fc.__class__).to eq(Functor)
    end

    it 'should support to proc' do
      f = Functor.new do |op, *a|
        [op, *a]
      end
      p = f.to_proc
      expect(p.class).to eq(Proc)
      expect(p.call(:+,1,2,3)).to eq([:+,1,2,3])
    end

    it 'should cache a new functor' do
      Functor.cache(:cached) do |op, *a, &b|
          [op, a, b]
        end
      expect(Functor.cache(:cached) + 1).to eq([:+, [1], nil])
     end

end
