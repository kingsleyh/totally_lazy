module Generators

  module Seq

    module_function

    def repeat(item)
      Sequence.new(Sequence::Generator.new do |g|
        loop { g.yield item.respond_to?(:call) ? item.call : item }
      end)
    end

    def range(lower, higher)
      Sequence.new(Sequence::Generator.new do |g|
        (lower..higher).each { |item| g.yield item }
      end)
    end

    def iterate(operator, item, start=1)
      Sequence.new(Sequence::Generator.new do |g|
        value = start
        loop do
          g.yield value
          value = value.send(operator, item)
        end
      end)
    end

    def primes
      Sequence.new(Sequence::Generator.new do |g|
        Prime.each { |n| g.yield n }
      end)
    end

    def fibonacci
      Sequence.new(Sequence::Generator.new do |g|
        i, j = 1, 1
        loop do
          g.yield i
          i, j = j, i + j
        end
      end)
    end

    def powers_of(v)
      Sequence.new(Sequence::Generator.new do |g|
        Seq.iterate(:+,1,0).each {|n| g.yield v**n}
      end)
    end


  end

  module Iter

    module_function

    def repeat(item)
      Repeater.new(item)
    end

    def range(lower, higher)
      Ranger.new(lower, higher)
    end

    def iterate(operator, item, start=1)
      Iterate.new(operator, item, start)
    end

    def primes
      Primes.new
    end

    def fibonacci
      Fibonacci.new
    end

    def powers_of(v)
      PowerOf.new(v)
    end

    class Repeater
      include Enumerable

      def initialize(item)
        @item = item
      end

      def each
        loop { yield(@item) }
      end
    end

    class Ranger
      include Enumerable

      def initialize(lower, higher)
        @lower = lower
        @higher = higher
      end

      def each
        (@lower..@higher).each { |i| yield i }
      end
    end

    class Iterate

      include Enumerable

      def initialize(operator, item, start)
        @operator = operator
        @item = item
        @start = start
      end

      def each
        value = @start
        loop do
          yield value
          value = value.send(@operator, @item)
        end
      end

    end

    class Primes
      include Enumerable

      def each
        Prime.each { |p| yield p }
      end
    end

    class Fibonacci
      include Enumerable

      def each
        i, j = 1, 1
        loop do
          yield i
          i, j = j, i + j
        end
      end
    end

    class PowerOf
      include Enumerable

      def initialize(v)
        @v = v
      end

      def each
        Iter.iterate(:+,1,0).each {|n| yield @v**n}
      end
    end

  end

end