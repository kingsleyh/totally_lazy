module Predicates

  module Where
    class WherePredicate

      attr_reader :ands, :ors

      def initialize
        @ands = empty
        @ors = empty
      end

      def where(predicates)
        @ands = predicates.is_a?(Pair::Pair) ? @ands.append(predicates) : @ands.join(Pair.from_map(predicates))
        self
      end

      def and(predicates)
        @ands = predicates.is_a?(Pair::Pair) ? @ands.append(predicates) : @ands.join(Pair.from_map(predicates))
        self
      end

      def or(predicates)
        @ors = predicates.is_a?(Pair::Pair) ? @ors.append(predicates) : @ors.join(Pair.from_map(predicates))
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