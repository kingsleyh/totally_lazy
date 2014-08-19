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

p sequence(1,2,3,4,5,6).unfilter(between(2,6)).entries




