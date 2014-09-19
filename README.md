# Totally Lazy for Ruby

This is a port of the java functional library [Totally Lazy](https://code.google.com/p/totallylazy/) to the ruby language. I've tried to get it as close as I can to the original concepts behind the java version of Totally Lazy but I'm still pretty far away from being happy with it.

### Status

[![Build Status](https://travis-ci.org/kingsleyh/totally_lazy.svg?branch=master)](https://travis-ci.org/kingsleyh/totally_lazy)
[![Gem Version](https://badge.fury.io/rb/totally_lazy.svg)](http://badge.fury.io/rb/totally_lazy)
[![Stories in Ready](https://badge.waffle.io/kingsleyh/totally_lazy.svg?label=ready&title=Ready)](http://waffle.io/kingsleyh/totally_lazy)
[![Coverage Status](https://coveralls.io/repos/kingsleyh/totally_lazy/badge.png?branch=master)](https://coveralls.io/r/kingsleyh/totally_lazy?branch=master)
[![Inline docs](http://inch-ci.org/github/kingsleyh/totally_lazy.png?branch=master)](http://inch-ci.org/github/kingsleyh/totally_lazy)
### Summary

* Tries to be as lazy as possible
* Supports method chaining
* Is primarily based on ruby Enumerators

### Install

In your bundler Gemfile

```ruby
 gem totally_lazy, '~>0.0.4' 
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
option(1).join(sequence(2,3,4)).join(sequence(5,6)).filter(odd).take(2) 
# lazily returns 1,3

Seq.iterate(:+, 1).filter(even).take(2).reduce(:+) # returns 6
```