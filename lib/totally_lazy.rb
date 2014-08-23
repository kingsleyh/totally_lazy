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
include Predicates::Where


# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).and(is even).and(is less_than 10)).entries







