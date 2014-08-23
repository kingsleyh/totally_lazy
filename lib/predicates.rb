module Predicates

  module Numbers

    # def even
    #   -> (v, meth=false, invert=false) do
    #     Type.responds(v, :even?)
    #     if invert
    #       v unless v.even?
    #     else
    #       v if v.even?
    #     end
    #   end
    # end

    def inverted(v, meth, pred)
      option((meth == :self) ? v.send(pred) : v.send(meth).send(pred))
    end

    def regular(v, meth, pred)
      option((meth == :self) ? v.send(pred) : v.send(meth).send(pred))
    end

    def inverted_value(v, value, meth, pred)
      option((meth == :self) ? v.send(pred, value) : v.send(meth).send(pred, value))
    end

    def regular_value(v, value, meth, pred)
       option((meth == :self) ? v.send(pred, value) : v.send(meth).send(pred, value))
    end

    def even
      -> (v, meth=:self, invert=false) do
        Type.responds(v, :even?)
        invert ? inverted(v, meth, :even?) : regular(v, meth, :even?)
      end
    end

    def odd
      -> (v, meth=:self, invert=false) do
        Type.responds(v, :odd?)
        invert ? inverted(v, meth, :odd?) : regular(v, meth, :odd?)
      end
    end

    def between(lower, higher)
      -> (v, invert=false) do
        Type.responds(v, :between?)
        if invert
          v unless v.between?(lower, higher)
        else
          v if v.between?(lower, higher)
        end
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
      -> (v) { v if v == value }
    end

    def greater_than(value)
      -> (v, meth=:self, invert=false) do
        Type.responds(v, :>)
        invert ? inverted_value(v, value, meth, :>) : regular_value(v, value, meth, :>)
      end
    end

    def less_than(value)
         -> (v, meth=:self, invert=false) do
           Type.responds(v, :<)
           invert ? inverted_value(v, value, meth, :<) : regular_value(v, value, meth, :<)
         end
    end


  end

end