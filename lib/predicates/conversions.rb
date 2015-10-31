module Predicates

  module Conversions

    def as_string
      simple_transform(:as_string, -> (v) { v.to_s } )
    end

    def as_int
      simple_transform(:as_int,  -> (v) { Type.responds(v, :to_i); v.to_i } )
    end

    def as_float
      simple_transform(:as_float, -> (v) { Type.responds(v, :to_f); v.to_f } )
    end

    def as_array
      simple_transform(:as_array,  -> (v) { [v] } )
    end

  end
end