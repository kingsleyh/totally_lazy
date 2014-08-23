require_relative 'type_check'
require_relative 'sequence'
require_relative 'pair'
require_relative 'option'
require_relative 'functor'
require_relative 'predicates/predicates'
require_relative 'predicates/compare'
require_relative 'predicates/conversions'
require_relative 'predicates/numbers'
require_relative 'predicates/where'
require_relative 'predicates/where_processor'

include Sequences
include Option
include Pair
include Predicates
include Predicates::Numbers
include Predicates::Conversions
include Predicates::Compare
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

# p sequence(pair(1, 2), pair(3, 4),pair(5,6)).filter(where(key: greater_than(1)).and(key: less_than(5)).or(key:odd).or(key:equal_to(5))).entries.size
# p sequence(pair(1, 2), pair(3, 4)).filter(where(key:odd)).entries







