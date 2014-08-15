class NoSuchElementException < RuntimeError
end

class Empty

  def each
    yield self
  end

end

module Sequences

  def sequence(*items)
    if items.size == 1
      if items.first.kind_of?(Range)
        Sequence.new(items.first)
      elsif items.first.kind_of?(Hash)
        Sequence.new(items.first)
      else
        Sequence.new(items)
      end
    else
      Sequence.new(items)
    end
  end

  def empty
    sequence(Empty.new)
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
      self.class <=> object.class
    end

    def map(&block)
      Sequence.new(self) { |yielder, val|
        yielder << block.call(val)
      }
    end

    alias collect map

    def select(&block)
      Sequence.new(self) { |yielder, val|
        if block.call(val)
          yielder << val
        end
      }
    end

    alias find_all select
    alias filter select

    def reject(&block)
      Sequence.new(self) { |yielder, val|
        if not block.call(val)
          yielder << val
        end
      }
    end

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
      sequence.next.kind_of?(Empty)
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
        result = []
        max_size = self.entries.max { |a, b| a.size <=> b.size }.size
        max_size.times do |i|
          result[i] = [self.entries.first.size]
          self.entries.each_with_index { |r, j| result[i][j] = r[i] }
        end
        result
        self.empty? ? raise(NoSuchElementException.new, 'The sequence was empty') : result.each { |i| g.yield i }
      end)
    end

    def join(target_sequence)
      Sequence.new(Sequence::Generator.new do |g|
        raise(Exception.new, 'The target (right side) must be a sequence') unless target_sequence.kind_of?(Sequences::Sequence)
        (self.entries << target_sequence.entries).flatten.each{|i| g.yield i}
      end)
    end
    alias + join
    alias << join

    private
    def sequence
      Sequence.new(self)
    end

  end

end













