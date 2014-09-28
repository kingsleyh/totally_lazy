module Predicates

  module Conversions

    def as_string
      simple_predicate(:as_string, -> (v) { v.to_s } )
    end

    def as_int
      simple_predicate(:as_int,  -> (v) { Type.responds(v, :to_i); v.to_i } )
    end

    def as_float
      simple_predicate(:as_float, -> (v) { Type.responds(v, :to_f); v.to_f } )
    end

    def as_array
      simple_predicate(:as_array,  -> (v) { [v] } )
    end

  end
end