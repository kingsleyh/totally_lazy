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

    def to_string
      -> (v) { v.to_s }
    end

    def to_int
      -> (v) { Type.responds(v, :to_i); v.to_i }
    end

    def to_float
      -> (v) { Type.responds(v, :to_i); v.to_f }
    end

    def to_array
      -> (v) { [v] }
    end

  end

end