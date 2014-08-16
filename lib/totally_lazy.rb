require_relative 'sequence'
require_relative 'pair'
require_relative 'option'

include Sequences
include Option
include Pair





# p sequence(pair(1, 2), pair(3, 4), pair(5, 6)).to_a
# p sequence(pair(1,2),sequence({1=>2},2),sequence(3,4)).to_a
