require_relative 'type_check'
require 'set'
require 'prime'
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
require_relative 'parallel/parallel'
require_relative 'generators'

include Sequences
include Option
include Pair
include Predicates
include Predicates::Numbers
include Predicates::Conversions
include Predicates::Compare
include Predicates::Where
include Generators



# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(
#       where( is(greater_than 2).or(is equal_to 5) )
#       ).entries
#
# sequence.filter(where.is(greater_than 2))



# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).or(is less_than 8 ).and(is odd)).entries

# p sequence(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12).filter(where(is greater_than 2).and(is less_than 8 ).and(is even)).entries

# p sequence(pair(1, 2), pair(3, 4)).filter(where(key:odd)).entries

# p sequence(1,2,3,4,5,6).map_concurrently(as_string,in_threads:10).entries
# p sequence(1,2,3,4,5,6).map_concurrently{|i| i+5 }.entries

# sequence(1,2,3,4,5).each_concurrently{|i| sleep rand(10); p i }



# p Seq.repeat('car').take(10).entries
# p Seq.range(1,1000000000000000000000000000).take(20).entries

# p Seq.iterate(:*,2).take(10).entries
# p Seq.fibonacci.take(20).entries
# p Iter.fibonacci.take(20).entries
# p Iter.primes.take(10).entries

# p Seq.powers_of(3).take(10).entries
# p Iter.powers_of(3).take(10).entries

# p Seq.iterate(:+,1,0).take(10).entries

# p Seq.range(1,4).cycle.take(20).entries
# p Iter.range(1,4).cycle.take(20).entries

# p Seq.iterate(:+, 1).filter(even).take(2).reduce(:+)








