require_relative 'type_check'
require_relative 'sequence'
require_relative 'pair'
require_relative 'option'
require_relative 'functor'
require_relative 'predicates'
require_relative 'where_processor'

include Sequences
include Option
include Pair
include Predicates::Numbers
include Predicates::Conversions
include Predicates::Compare


module Predicates
  module Where
    class WherePredicate

      attr_reader :ands, :ors

      def initialize
        @ands = empty
        @ors = empty
      end

      def where(predicates)
        @ands = predicates.is_a?(Pair) ? @ands.append(predicates) : @ands.join(Pair.from_map(predicates))
        self
      end

      def and(predicates)
        @ands = predicates.is_a?(Pair) ? @ands.append(predicates) : @ands.join(Pair.from_map(predicates))
        self
      end

      def or(predicates)
        @ors = predicates.is_a?(Pair) ? @ors.append(predicates) : @ors.join(Pair.from_map(predicates))
        self
      end

    end

    def where(predicate_map)
      WherePredicate.new.where(predicate_map)
    end

    def is(single_predicate)
      pair(:self, single_predicate)
    end

  end


end

include Predicates::Where


# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(
#       where( is(greater_than 2).or(is equal_to 5) )
#       ).entries
#
# sequence.filter(where.is(greater_than 2))


# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).or(is equal_to 5)).entries
# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).and(is even).or(is equal_to(8))).entries

# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).and(is even).or(is equal_to(8)).or(is equal_to(9))).entries
# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).or(is less_than 8 ).and(is odd)).entries

# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).and(is less_than 8 ).and(is even)).entries

p sequence(pair(1,2),pair(3,4)).filter(where(key:greater_than(1))).entries







