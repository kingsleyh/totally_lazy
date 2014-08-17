module Predicates

  module Numbers

    def even
      -> (v) { Type.responds(v, :even?); v if v.even? }
    end

    def odd
      -> (v) { Type.responds(v, :odd?); v if v.odd? }
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