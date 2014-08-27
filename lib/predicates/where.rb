module Predicates

  module Where
    class WherePredicate

      attr_reader :predicates

      def initialize
        @predicates = empty
      end

      def where(predicates)
        @predicates = predicates.is_a?(Pair::Pair) ? @predicates.append(predicates) : @predicates.join(Pair.from_map(predicates))
        self
      end

      def and(predicates)
        @predicates = predicates.is_a?(Pair::Pair) ? @predicates.append(predicates) : @predicates.join(Pair.from_map(predicates))
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