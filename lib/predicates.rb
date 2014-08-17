module Predicates

  module Numbers

    def even
      -> (v, invert=false) do
        Type.responds(v, :even?)
        if invert
          v unless v.even?
        else
          v if v.even?
        end
      end
    end

    def odd
      -> (v, invert=false) do
        Type.responds(v, :odd?)
        if invert
          v unless v.odd?
        else
          v if v.odd?
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

end