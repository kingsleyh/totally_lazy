module Pair

  def pair(first, second)
    Pair.new(first, second)
  end

  def from_map(a_map)
    Pair.from_map(a_map)
  end

  class Pair

    def initialize(first, second)
      @first = -> { first }
      @second = -> { second }
    end

    def first
      @first.call
    end

    alias key first

    def second
      @second.call
    end

    def first=(v)
     @first = -> { v }
    end
    alias key= first=

    def second=(v)
      @second = -> { v }
    end
    alias value= second=

    def each(&block)
      [first,second].each do |i|
        block.call(i)
      end
    end

    alias value second

    def to_map
      {first => second}
    end

    def self.from_map(a_map)
      sequence(a_map).map { |k, v| Pair.new(k, v) }
    end

    def to_s
      Type.responds_all(sequence(first, second), :to_s)
      {first.to_s => second.to_s}
    end

    def to_i
      Type.responds_all(sequence(first, second), :to_i)
      {first.to_i => second.to_i}
    end

    def to_f
      Type.responds_all(sequence(first, second), :to_f)
      {first.to_f => second.to_f}
    end

    def values
      sequence(first, second)
    end

  end


end
