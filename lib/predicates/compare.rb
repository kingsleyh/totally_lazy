module Predicates

  module Compare

    def equals(value)
      -> (v, meth=:self, invert=false) do
        invert ? inverted_value(v, value, meth, :==) : regular_value(v, value, meth, :==)
      end
    end

    alias equal_to equals

    def greater_than(value)
      -> (v, meth=:self, invert=false) do
        invert ? inverted_value(v, value, meth, :>) : regular_value(v, value, meth, :>)
      end
    end

    def less_than(value)
      -> (v, meth=:self, invert=false) do
        invert ? inverted_value(v, value, meth, :<) : regular_value(v, value, meth, :<)
      end
    end

  end

end