require_relative 'type_check'
require_relative 'sequence'
require_relative 'pair'
require_relative 'option'
require_relative 'functor'
require_relative 'predicates'

include Sequences
include Option
include Pair
include Predicates::Numbers
include Predicates::Conversions
include Predicates::Compare


module Predicates

  module Where
    class WherePredicate

      attr_reader :predicates

      def initialize
        @predicates = empty
      end

      def where(predicates)
        @predicates = predicates.is_a?(Pair) ? @predicates.append(predicates) : @predicates.join(Pair.from_map(predicates))
        self
      end

      def and(predicates)
        @predicates = predicates.is_a?(Pair) ? @predicates.append(predicates) : @predicates.join(Pair.from_map(predicates))
        self
      end
      #
      # def or(predicate_map)
      #   @predicates << {predicates: predicate_map, :operation => :or}
      #   self
      # end

      # def is(single_predicate)
      #   pair(:self,single_predicate)
      # end


    end

    def where(predicate_map)
      WherePredicate.new.where(predicate_map)
    end

    def is(single_predicate)
      pair(:self, single_predicate)
    end

  end

end


class WhereProcessor
  def initialize(value)
    @value = value
  end

  def apply(predicates)
    @value unless predicates.map { |x| x.value.call(@value, x.key) }.contains?(none)
  end
end


include Predicates::Where

# p WherePredicate.new.where(1).predicates


p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).and(is even).and(is less_than 10)).entries


# p sequence(1,2,3,4,5,6).filter(where(greaterThan(2)).and(lessThan(4))).entries



