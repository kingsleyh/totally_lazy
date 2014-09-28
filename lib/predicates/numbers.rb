module Predicates

  module Numbers

    def even
      self_predicate(:even,:even?)
    end

    def odd
      self_predicate(:even,:odd?)
    end
    #
    # def between(lower, higher)
    #   -> (v, meth=:self, invert=false) do
    #     invert ? inverted(v, meth, :between?) : regular(v, meth, :between?)
    #   end
    # end

  end

end