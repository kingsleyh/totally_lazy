# PLEASE NOTE - This project is no longer being actively maintained. It has now been moved to https://github.com/raymanoz/totally_lazy

# Totally Lazy for Ruby

This is a port of the java functional library [Totally Lazy](https://code.google.com/p/totallylazy/) to the ruby language. I've tried to get it as close as I can to the original concepts behind the java version of Totally Lazy but I'm still pretty far away from being happy with it.

### Status

DEAD! Do not use.

### Summary

* Tries to be as lazy as possible
* Supports method chaining
* Is primarily based on ruby Enumerators

### Install

This gem requires ruby 2.x.x

In your bundler Gemfile

```ruby
 gem totally_lazy, '~>0.0.6' 
```

Or with rubygems

```
 gem install totally_lazy
```

### Examples

The following are some simple examples of the currently implemented functionality.

```ruby
require 'totally_lazy'

sequence(1,2,3,4).filter(even) # lazily returns 2,4
sequence(1,2).map(as_string) # lazily returns "1","2"
sequence(1, 2).map_concurrently(to_string) # lazily distributes the work to background threads
sequence(1,2,3).take(2) # lazily returns 1,2
sequence(1,2,3).drop(2) # lazily returns 3
sequence(1,2,3).tail # lazily returns 2,3
sequence(1,2,3).head # eagerly returns 1
sequence(1,2,3).head_option # eagerly returns an option
some(sequence(1,2,3)).get_or_else(empty) # eagerly returns value or else empty sequence
sequence(1, 2, 3, 4, 5).filter(where(is greater_than 2).and(is odd)) # lazily returns 3,5
sequence(pair(1, 2), pair(3, 4)).filter(where(key:odd)) # lazily returns 1,3
```

#### Sequences

* sequence wraps whatever is passed without modification - e.g. sequence([1,2,3]).head returns the array [1,2,3]
* if you have a single array you can [1,2,3].to_seq which returns a flattened sequence - e.g. [1,2,3].to_seq.head returns 1
* you can also do sequence([1,2,3]).flatten to get sequence([1,2,3]).flatten.head returns 1

#### Generators

There are 2 types of generators:

* Seq - returns a sequence
* Iter - returns a regular ruby enumerator

```ruby
Seq.range(1, 4) # lazily returns 1,2,3,4
Seq.repeat("car") # lazily returns an infinite sequence of "car"s
Seq.iterate(:+, 1) # lazily returns 1,2,3 ... to infinity
Seq.range(1, 4).cycle # lazily returns 1,2,3,4,1,2,3,4,1,2,3,4 infinitely
Seq.primes # lazily returns every prime number
Seq.fibonacci # lazily returns the fibonacci sequence
Seq.powers_of(3) # lazily returns the powers of 3 (i.e 1,3,9,27 ...)

Iter.range(1,4) # example with Iter: lazily returns 1,2,3,4 with a regular ruby enumerator
```

Naturally you can combine these operations together:

```ruby
option(1).join(sequence(2,3,4)).join(sequence(5,6)).filter(odd).take(2) # lazily returns 1,3

Seq.iterate(:+, 1).filter(even).take(2).reduce(:+) # returns 6
```

### Predicates

You can supply basic predicates as follows:

##### numbers

    sequence(1,2,3).filter(even) # returns 2

##### conversions

    sequence(1,2,3).map(as_string) # returns ["1","2","3"]

##### comparisons

    sequence(1,2,3).filter(equals(2) # return 2

##### where - for self or objects

**using self**

When the predicate applies to an item in the sequence you use the **is** keyword with *where* to indicate the operation is on *self*

    sequence(1,2,3).filter(where is greater_than 2)

**using objects**

When the predicate applies to a method on an object in the sequence then you supply hashmap of method_name:predicate (without using *is*)

    sequence(pair(1,2),pair(3,4)).filter(where key:greater_than(3))

(pair has methods key and value)

##### Regex

You can use a regex predicate

   sequence("apple","pear").filter(matches(/app/))
   sequence(pair("apple",1),pair("pear",2)).filter(where(key:matches(/app/)))

#### Custom Transformer

There is a built in helper for a simple transform

* simple_transform

##### simple_transform

For example:

    def as_uppercase
      simple_transform(:as_uppercase, -> (v) { v.upcase })
    end

    sequence("apple","pear").map(as_uppercase) # returns ["APPLE","PEAR"]


#### Custom Predicates

Writing a custom predicate is very easy and there are 3 built in helpers:

* value predicate
* self predicate

##### value_predicate

For example:

    def greater_than_or_equal_to(value)
      value_predicate(:greater_than_or_equal_to,:>=,value)
    end

    sequence(1,2,3).filter(greater_than_or_equal_to 2)
    sequence(1,2,3).filter(where is greater_than_or_equal_to 2)

##### self_predicate

For example:

    def is_valid
      self_predicate(:is_valid, :is_valid)
    end

    sequence(OpenStruct.new(is_valid:true,name:'apple'),OpenStruct.new(is_valid:false,name:'pear')).filter(is_valid).to_a
    => [#<OpenStruct is_valid=true, name="apple">]

