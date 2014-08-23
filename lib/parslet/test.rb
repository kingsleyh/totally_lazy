require 'parslet'

class MiniP < Parslet::Parser
  # Single character rules
  rule(:lparen)     { str('(') >> space? }
  rule(:rparen)     { str(')') >> space? }
  rule(:comma)      { str(',') >> space? }

  rule(:space)      { match('\s').repeat(1) }
  rule(:space?)     { space.maybe }

  # Things
  rule(:integer)    { match('[0-9]').repeat(1).as(:int) >> space? }
  rule(:identifier) { match['a-z'].repeat(1) }
  rule(:operator)   { match('[+]') >> space? }

  # Grammar parts
  rule(:sum)        { integer.as(:left) >> operator.as(:op) >> expression.as(:right) }
  rule(:arglist)    { expression >> (comma >> expression).repeat }
  rule(:funcall)    { identifier.as(:funcall) >> lparen >> arglist.as(:arglist) >> rparen }

  rule(:expression) { funcall | sum | integer }
  root :expression
end

require 'pp'
pp MiniP.new.parse("puts(1 + 2 + 3, 45)")


sequence(1,2,3).filter(where('self (is > 1 and is < 3) '))

sequence(1,2,3,4,5,6).where('(self is greater_than 3 and self is even)')

