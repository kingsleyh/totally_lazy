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
    alias value second

    def to_map
      {first => second}
    end

    def self.from_map(a_map)
     sequence(a_map).map{|k,v| Pair.new(k,v)}
    end

    def to_s
      to_map.inspect
    end

    def values
      sequence(first, second)
    end

  end


end
