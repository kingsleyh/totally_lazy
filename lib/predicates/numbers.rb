module Predicates

  module Numbers

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
    #
    # def between(lower, higher)
    #   -> (v, meth=:self, invert=false) do
    #     invert ? inverted(v, meth, :between?) : regular(v, meth, :between?)
    #   end
    # end

  end

end