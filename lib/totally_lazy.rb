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
require_relative 'any'
require_relative 'utils'

include Sequences
include Option
include Pair
include Predicates
include Predicates::Numbers
include Predicates::Conversions
include Predicates::Compare
include Predicates::Where
include Generators
include Any
include Maps


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

#
# class Person
#   attr_accessor :first_name,:last_name,:age
#   def initialize(first_name,last_name,age)
#     @first_name = first_name
#     @last_name = last_name
#     @age = age
#   end
#
#   def name
#     @first_name
#   end
#
# end
#
# people = Seq.repeat(-> {Person.new(Any.string,Any.string,Any.string)}).take(10)
#
# p people.filter(where(first_name:matches(/s/))).map(&:first_name).entries

# p sequence(pair('apples','pairs'),pair('banana','orange'),pair('apples','melon')).filter(where key:matches(/app/)).entries

# p Seq.repeat(-> { rand(9)}).take(10).to_a.join.to_i

# p  Seq.range(1,100000000000000).shuffle.take(10).to_a

# a = sequence(pair(7,8),sequence(1,2),sequence(3,sequence(5,6)),sequence(pair(:apple,99), option(1),none),[10,11],{:apple => 8,:pear => 9}).serialize
#
# p a
# p deserialize(a)[5]

# p sequence(pair(1,2))[0]

# p empty.gan(ser).entries

# def countdown(c,n)
#   return if n.zero? # base case
#   c << n
#   countdown(c,n-1)    # getting closer to base case
# end
#
#
# a = []
# countdown(a,5)
# p a


# s1 = Seq.range(1,3000000)
# s2 = Seq.range(1,3000000)
#
# s = Time.now
# p s1.join2(s2).head
# f = Time.now
# p f - s
#
#
# s = Time.now
# p s1.join(s2).head
# f = Time.now
# p f - s


# p Seq.range(1,20).filter(odd).update(10).to_a

# require 'ostruct'
# #
# #
# # p Seq.repeat(->{OpenStruct.new(name:Any.string(5),age:Any.int(2))}).take(100000).update(age:11,name:'woops').take(1000).head
# #
# # p sequence({apple:1,pear:2}).each_slice(2).map{|s| [s[0],s[1]]}.to_a
#
# a = Seq.range(1,10).map{|n| OpenStruct.new(name:Any.string(5),age:Any.int(2)) }.to_a
#
# orig = sequence(a)
#
# updates = orig.filter(where(age:greater_than(70))).update(age:2)
#
# p orig.count
# p updates.count



#













