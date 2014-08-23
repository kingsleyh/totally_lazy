class NoSuchElementException < RuntimeError
end

class UnsupportedTypeException < RuntimeError
end





module Sequences

  def sequence(*items)
    if items.size == 1
      if [Range, Hash].include?(items.first.class)
        Sequence.new(items.first)
      elsif items.first.nil?
        empty
      else
        Sequence.new(items)
      end
    else
      Sequence.new(items)
    end
  end

  def empty
    Empty.new
  end

  class Sequence < Enumerator

    include Comparable

    def initialize(obj, &block)
      super() { |yielder|
        begin
          obj.each { |x|
            if block
              block.call(yielder, x)
            else
              yielder << x
            end
          }
        rescue StopIteration
        end
      }
    end

    def <=>(object)
      self.entries <=> object.entries
    end

    def map(predicate=nil, &block)
      if predicate
        Sequence.new(self) { |yielder, val|
          v = predicate.is_a?(WherePredicate) ? WhereProcessor.new(val).apply(predicate) : predicate.call(val)
          yielder << v unless v.nil?
        }
      else
        Sequence.new(self) { |yielder, val|
          yielder << block.call(val)
        }
      end
    end

    alias collect map

    def select(predicate=nil, &block)
      if predicate
        Sequence.new(self) { |yielder, val|
          v = predicate.is_a?(WherePredicate) ? WhereProcessor.new(val).apply(predicate.predicates) : predicate.call(val)
          yielder << v unless v.nil?
        }
      else
        Sequence.new(self) { |yielder, val|
          if block.call(val)
            yielder << val
          end
        }
      end
    end

    alias find_all select
    alias filter select

    def reject(predicate=nil, &block)
      if predicate
        Sequence.new(self) { |yielder, val|
          v = predicate.is_a?(WherePredicate) ? WhereProcessor.new(val).apply(predicate.predicates) : predicate.call(val,:self,true)
          yielder << v unless v.nil?
        }
      else
        Sequence.new(self) { |yielder, val|
          unless block.call(val)
            yielder << val
          end
        }
      end
    end

    alias unfilter reject

    def grep(pattern)
      Sequence.new(self) { |yielder, val|
        if pattern === val
          yielder << val
        end
      }
    end

    def drop(n)
      dropped = 0
      Sequence.new(self) { |yielder, val|
        if dropped < n
          dropped += 1
        else
          yielder << val
        end
      }
    end

    def drop_while(&block)
      dropping = true
      Sequence.new(self) { |yielder, val|
        if dropping
          if not block.call(val)
            yielder << val
            dropping = false
          end
        else
          yielder << val
        end
      }
    end

    def take(n)
      taken = 0
      Sequence.new(self) { |yielder, val|
        if taken < n
          yielder << val
          taken += 1
        else
          raise StopIteration
        end
      }
    end

    def take_while(&block)
      Sequence.new(self) { |yielder, val|
        if block.call(val)
          yielder << val
        else
          raise StopIteration
        end
      }
    end

    def flat_map(&block)
      Sequence.new(self) { |yielder, val|
        ary = block.call(val)
        # TODO: check ary is an Array
        ary.each { |x|
          yielder << x
        }
      }
    end

    alias collect_concat flat_map

    def zip(*args, &block)
      enums = [self] + args
      Sequence.new(self) { |yielder, val|
        ary = enums.map { |e| e.next }
        if block
          yielder << block.call(ary)
        else
          yielder << ary
        end
      }
    end

    def [](n)
      Sequence.new(self).entries[n]
    end

    alias get []

    def empty?
      begin
        sequence.peek_values.empty?
      rescue StopIteration
        true
      end
    end

    def head
      sequence.empty? ? raise(NoSuchElementException.new, 'The sequence was empty') : sequence.first
    end

    def head_option
      sequence.empty? ? none : some(sequence.first)
    end

    def last
      sequence.empty? ? raise(NoSuchElementException.new, 'The sequence was empty') : sequence.entries.last
    end

    def last_option
      sequence.empty? ? none : some(sequence.entries.last)
    end

    def contains?(value)
      sequence.empty? ? false : sequence.entries.include?(value)
    end

    def tail
      Sequence.new(Sequence::Generator.new do |g|
        self.empty? ? raise(NoSuchElementException.new, 'The sequence was empty') : self.drop(1).each { |i| g.yield i }
      end)
    end

    def init
      Sequence.new(Sequence::Generator.new do |g|
        size = self.count
        self.empty? ? raise(NoSuchElementException.new, 'The sequence was empty') : self.first(size-1).each { |i| g.yield i }
      end)
    end

    def shuffle
      Sequence.new(Sequence::Generator.new do |g|
        self.empty? ? raise(NoSuchElementException.new, 'The sequence was empty') : self.entries.shuffle.each { |i| g.yield i }
      end)
    end

    def transpose
      Sequence.new(Sequence::Generator.new do |g|
        if self.empty?
          raise(NoSuchElementException.new, 'The sequence was empty')
        else
          raise(Exception.new, 'The subject of transposition must be multidimensional') unless self.to_a.first.is_a?(Array)
        end
        result = []
        max = option(self.to_a.max { |a, b| a.size <=> b.size })
        max_size = max.get_or_throw(NoSuchElementException,'The option was empty').size
        max_size.times do |i|
          result[i] = [self.to_a.first.size]
          self.to_a.each_with_index { |r, j| result[i][j] = r[i] }
        end
        result
        result.each { |i| g.yield i }
      end)
    end

    def join(target_sequence)
      Sequence.new(Sequence::Generator.new do |g|
        raise(Exception.new, 'The target (right side) must be a sequence') unless target_sequence.kind_of?(Sequences::Sequence)
        elements = self.entries
        elements = elements.reject { |i| i.is_a?(Empty) }
        (elements << target_sequence.entries).flatten.each { |i| g.yield i }
      end)
    end

    alias << join

    def add(target_sequence)
      Sequence.new(Sequence::Generator.new do |g|
        (self.entries + target_sequence.entries).each { |i| g.yield i }
      end)
    end

    alias + add

    def append(item)
      Sequence.new(Sequence::Generator.new do |g|
        elements = self.entries
        elements = elements.reject { |i| i.is_a?(Empty) }
        (elements << item).each { |i| g.yield i }
      end)
    end

    def to_seq
      Sequence.new(Sequence::Generator.new do |g|
        self.entries.map { |e| Type.responds(e, :entries); e.entries }.flatten.each { |i| g.yield i }
      end)
    end

    def from_pairs
      Sequence.new(Sequence::Generator.new do |g|
        self.entries.map { |e| Type.check(e, Pair::Pair); [e.key, e.value] }.flatten.each { |i| g.yield i }
      end)
    end

    def to_a
      execution = {
          Sequences::Sequence => -> { self.entries.map { |s| s.entries } },
          Pair::Pair => -> { self.entries.map { |pair| pair.to_map } }
      }
      if self.empty?
        self.entries
      else

        first_item = self.peek_values.first.class
        execution[first_item].nil? ? self.entries : execution[first_item].call
      end
    end

    def all
      to_a.flatten
    end

    def get_or_else(index, or_else)
      blank?(sequence[index]) ? or_else : sequence[index]
    end

    def get_option(index)
      blank?(sequence[index]) ? none : some(sequence[index])
    end

    def get_or_throw(index,exception,message='')
      blank?(sequence[index]) ? raise(exception,message) : sequence[index]
    end

    private
    def sequence
      Sequence.new(self)
    end

    def blank?(item)
      item.respond_to?(:empty?) ? item.empty? : !item
    end

  end

  class Empty < Sequence

    def initialize(obj=[], &block)
      super(obj) { |yielder|
        begin
          obj.each { |x|
            if block
              block.call(yielder, x)
            else
              yielder << x
            end
          }
        rescue StopIteration
        end
      }
    end

  end

end















