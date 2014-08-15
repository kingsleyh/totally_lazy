# Totally Lazy for Ruby

This is a port of the java functional library [Totally Lazy](https://code.google.com/p/totallylazy/) to the ruby language. I've tried to get it as close as I can to the original concepts behind the java version of Totally Lazy but I'm still pretty far away from being happy with it.

### Summary

* Tries to be as lazy as possible
* Supports method chaining
* Is primarily based on ruby Enumerators

### Install

In your bundler Gemfile

```ruby
 gem totally_lazy, '~>0.0.2' 
```

Or with rubygems

```
 gem install totally_lazy
```

### Examples

The following are some simple examples of the currently implemented functionality.

```ruby
require 'totally_lazy'

sequence(1,2,3,4).filter{|i| i.even? } # lazily returns 2,4
sequence(1,2).map{|i| i.to_s} # lazily returns "1","2"
sequence(1,2,3).take(2) # lazily returns 1,2
sequence(1,2,3).drop(2) # lazily returns 3
sequence(1,2,3).tail # lazily returns 2,3
sequence(1,2,3).head # eagerly returns 1
sequence(1,2,3).head_option # eagerly returns an option
some(sequence(1,2,3)).get_or_else(empty) # eagerly returns value or else empty sequence
```

Naturally you can combine these operations together:

```ruby
option(1).join(sequence(2,3,4)).join(sequence(5,6)).filter{|i| i.odd?}.take(2) 
# lazily returns 1,3
```