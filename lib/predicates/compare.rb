module Predicates

  module Compare

    def equals(value)
      value_predicate(:equals,:==,value)
    end

    alias equal_to equals

    def greater_than(value)
      value_predicate(:greater_than,:>,value)
    end

    def less_than(value)
      value_predicate(:less_than,:<,value)
    end

    def matches(value)
      regex_predicate(:matches,value)
    end

  end

end