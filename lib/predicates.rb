module Predicates

  module Numbers

    def inverted(v, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v unless v.send(pred)
      else
        r = v.send(meth)
        Type.responds(r, pred)
        v unless r.send(pred)
      end
    end

    def regular(v, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v if v.send(pred)
      else
        r = v.send(meth)
        Type.responds(r, pred)
        v if r.send(pred)
      end
    end

    def inverted_value(v, value, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v unless v.send(pred, value)
      else
        r = v.send(meth)
        Type.responds(r, pred)
        v unless r.send(pred, value)
      end
    end

    def regular_value(v, value, meth, pred)
      if meth == :self
        Type.responds(v, :>)
        v if v.send(pred, value)
      else
        r = v.send(meth)
        Type.responds(r, :>)
        v if r.send(pred, value)
      end
    end

    def even
      -> (v, meth=:self, invert=false) do
        invert ? inverted(v, meth, :even?) : regular(v, meth, :even?)
      end
    end

    def odd
      -> (v, meth=:self, invert=false) do
        invert ? inverted(v, meth, :odd?) : regular(v, meth, :odd?)
      end
    end

    def between(lower, higher)
      -> (v, meth=:self, invert=false) do
        invert ? inverted(v, meth, :between?) : regular(v, meth, :between?)
      end
    end

  end

  module Conversions

    def as_string
      -> (v) { v.to_s }
    end

    def as_int
      -> (v) { Type.responds(v, :to_i); v.to_i }
    end

    def as_float
      -> (v) { Type.responds(v, :to_i); v.to_f }
    end

    def as_array
      -> (v) { [v] }
    end

  end

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

    def is_nil(value)
      -> (v, meth=:self, invert=false) do
        invert ? inverted_value(v, value, meth, :nil?) : regular_value(v, value, meth, :nil?)
      end
    end

  end

  # module Where
  #   class WherePredicate
  #
  #     attr_reader :predicates
  #
  #     def initialize
  #       @predicates = empty
  #     end
  #
  #     def where(predicates)
  #       @predicates = predicates.is_a?(Pair) ? @predicates.append(predicates) : @predicates.join(Pair.from_map(predicates))
  #       self
  #     end
  #
  #     def and(predicates)
  #       @predicates = predicates.is_a?(Pair) ? @predicates.append(predicates) : @predicates.join(Pair.from_map(predicates))
  #       self
  #     end
  #
  #   end
  #
  #   def where(predicate_map)
  #     WherePredicate.new.where(predicate_map)
  #   end
  #
  #   def is(single_predicate)
  #     pair(:self, single_predicate)
  #   end
  #
  # end


end