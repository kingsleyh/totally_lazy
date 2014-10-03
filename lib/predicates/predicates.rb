module Predicates

  class Predicate

    def inverted(v, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v unless v.send(pred)
      end
    end

    def regular(v, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v if v.send(pred)
      else
        r = v.send(meth)
        Type.responds(r, pred)
        v if r.send(pred)
      end
    end

    def inverted_value(v, value, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v unless v.send(pred, value)
      end
    end

    def regular_value(v, value, meth, pred)
      if meth == :self
        Type.responds(v, pred)
        v if v.send(pred, value)
      else
        r = v.send(meth)
        Type.responds(r, pred)
        v if r.send(pred, value)
      end
    end

    def regular_regex(v, regex, meth)
      if meth == :self
        v if v.to_s.match(regex)
      else
        r = v.send(meth)
        v if r.to_s.match(regex)
      end
    end

    def inverted_regex(v, regex, meth)
      if meth == :self
        v unless v.to_s.match(regex)
      else
        r = v.send(meth)
        v unless r.to_s.match(regex)
      end
    end

  end

  def value_predicate(name, pred, value)
    ValuePredicate.new(name, pred, value)
  end

  def regex_predicate(name, value)
    RegexPredicate.new(name, value)
  end

  def self_predicate(name,pred)
    SelfPredicate.new(name,pred)
  end

  def simple_predicate(name,exec)
    SimplePredicate.new(name,exec)
  end


  class ValuePredicate < Predicates::Predicate

    attr_reader :name, :pred, :value

    def initialize(name, pred, value)
      @name = name
      @pred = pred
      @value = value
    end

    def exec
      -> (v, meth=:self, invert=false) do
        invert ? inverted_value(v, @value, meth, @pred) : regular_value(v, @value, meth, @pred)
      end
    end

  end

  class SelfPredicate < Predicates::Predicate

    attr_reader :name, :pred

    def initialize(name, pred)
      @name = name
      @pred = pred
    end

    def exec
      -> (v, meth=:self, invert=false) do
        invert ? inverted(v, meth, @pred) : regular(v, meth, @pred)
      end
    end

  end

  class SimplePredicate < Predicates::Predicate
    attr_reader :name, :exec

    def initialize(name, exec)
      @name = name
      @exec = exec
    end

  end

  class RegexPredicate < Predicates::Predicate

    attr_reader :name, :value

    def initialize(name, value)
      @name = name
      @value = value
    end

    def exec
      -> (v, meth=:self, invert=false) do
        invert ? inverted_regex(v, @value, meth) : regular_regex(v, @value, meth)
      end
    end

  end


end