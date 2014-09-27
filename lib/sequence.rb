class NoSuchElementException < RuntimeError
end

class UnsupportedTypeException < RuntimeError
end

class UnsupportedMethodException < RuntimeError
end

module Sequences

  # Creates a sequence
  #
  # == Parameters:
  # items::
  #   Varargs - any valid ruby objects can be supplied
  #
  # == Returns:
  # A sequence
  #
  # == Examples
  #
  #   sequence(1,2,3,4).filter(even) # lazily returns 2,4
  #   sequence(1,2).map(as_string) # lazily returns "1","2"
  #   sequence(1, 2).map_concurrently(to_string) # lazily distributes the work to background threads
  #   sequence(1,2,3).take(2) # lazily returns 1,2
  #   sequence(1,2,3).drop(2) # lazily returns 3
  #   sequence(1,2,3).tail # lazily returns 2,3
  #   sequence(1,2,3).head # eagerly returns 1
  #   sequence(1,2,3).head_option # eagerly returns an option
  #   some(sequence(1,2,3)).get_or_else(empty) # eagerly returns value or else empty sequence
  #   sequence(1, 2, 3, 4, 5).filter(where(is greater_than 2).and(is odd)) # lazily returns 3,5
  def sequence(*items)
    if items.size == 1
      if [Range, Hash, Array, Set].include?(items.first.class)
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

  # Creates an empty sequence
  #
  # == Returns:
  # An empty sequence
  #
  # == Examples
  #
  #   empty
  #   some(sequence(1,2,3)).get_or_else(empty) # eagerly returns value or else empty sequence
  def empty
    Empty.new
  end

  def deserialize(data)
    sequence(data).deserialize
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
          v = predicate.is_a?(WherePredicate) ? WhereProcessor.new(val).apply(predicate.predicates) : predicate.call(val)
          yielder << v unless v.nil?
        }
      else
        Sequence.new(self) { |yielder, val|
          yielder << block.call(val)
        }
      end
    end

    alias collect map

    # def reduce(operation_or_value=nil)
    #   case operation_or_value
    #     when Symbol
    #       # convert things like reduce(:+) into reduce { |s,e| s + e }
    #       return reduce { |s,e| s.send(operation_or_value, e) }
    #     when nil
    #       acc = nil
    #     else
    #       acc = operation_or_value
    #   end
    #
    #   each do |a|
    #     if acc.nil?
    #       acc = a
    #     else
    #       acc = yield(acc, a)
    #     end
    #   end
    #
    #   return acc
    # end

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
          v = predicate.is_a?(WherePredicate) ? WhereProcessor.new(val).apply(predicate.predicates, true) : predicate.call(val, :self, true)
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
      Sequence.new(Sequence::Generator.new do |g|
        self.each_with_index do |v, i|
          if i < n
            g.yield v
          else
            raise StopIteration
          end
        end
      end)
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
        max_size = max.get_or_throw(NoSuchElementException, 'The option was empty').size
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
        self.entries.push(target_sequence.entries).flatten.each { |i| g.yield i unless i.is_a?(Empty) }
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

    def to_maps(symbolize=true)
      Sequence.new(Sequence::Generator.new do |g|
        self.each_slice(2) do |k, v|
          if symbolize
            g.yield k.to_s.to_sym => v
          else
            g.yield k => v
          end
        end
      end)
    end

    def from_pairs
      Sequence.new(Sequence::Generator.new do |g|
        self.entries.map { |e| Type.check(e, Pair::Pair); [e.key, e.value] }.flatten.each { |i| g.yield i }
      end)
    end

    def from_arrays
      Sequence.new(Sequence::Generator.new do |g|
        self.entries.map { |e| Type.check(e, Array); e }.flatten.each { |i| g.yield i }
      end)
    end

    def from_sets
      Sequence.new(Sequence::Generator.new do |g|
        self.entries.map { |e| Type.check(e, Set); e.to_a }.flatten.each { |i| g.yield i }
      end)
    end

    def in_pairs
      Sequence.new(Sequence::Generator.new do |g|
        self.each_slice(2) { |k, v| g.yield pair(k, v) }
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

    def update(item)
      Sequence.new(Sequence::Generator.new do |g|
        if item.is_a?(Hash)
          self.map do |e|
            item.map { |k, v|
              raise(UnsupportedMethodException.new, "Tried to call method: #{k} on #{e.class} but method not supported") unless e.respond_to?(k) or e.respond_to?(":#{k}=")
              begin
                e.send(k, v) if e.respond_to?(k); e
              rescue
                e.send("#{k}=", v) if e.respond_to?("#{k}="); e
              end
            }.first
          end
        else
          self.map { item }
        end.each { |i| g.yield i }
      end)
    end

    def marshal_dump
      serialize
    end

    def marshal_load(data)
      Sequence.new(data).deserialize
    end

    def serialize
      c = []
      serializer(c, self.entries)
      c
    end

    def deserialize
      c = []
      deserializer(c, self.entries)
      Sequence.new(c)
    end

    def all
      to_a.flatten
    end

    def sorting_by(*attr, &block)
      if attr.empty?
        Sequence.new(Sequence::Generator.new do |g|
          self.sort_by { |e| block.call(e) }.each { |i| g.yield i }
        end)
      else
        Sequence.new(Sequence::Generator.new do |g|
          self.sort_by { |e| attr.map{|v| e.send(v)} }.each { |i| g.yield i }
        end)
      end
    end

    def sorting
      Sequence.new(Sequence::Generator.new do |g|
        self.sort.each { |i| g.yield i }
      end)
    end

    def get_or_else(index, or_else)
      blank?(sequence[index]) ? or_else : sequence[index]
    end

    def get_option(index)
      blank?(sequence[index]) ? none : some(sequence[index])
    end

    def get_or_throw(index, exception, message='')
      blank?(sequence[index]) ? raise(exception, message) : sequence[index]
    end

    def drop_nil
      Sequence.new(Sequence::Generator.new do |g|
        self.reject { |e| e.nil? }.each { |i| g.yield i }
      end)
    end

    def map_concurrently(predicate=nil, options={}, &block)
      if predicate
        Sequence.new(Sequence::Generator.new do |g|
          Parallel.map(self.entries, options) { |val|
            predicate.is_a?(WherePredicate) ? WhereProcessor.new(val).apply(predicate.predicates) : predicate.call(val)
          }.each { |i| g.yield i unless i.nil? }
        end)
      else
        Sequence.new(Sequence::Generator.new do |g|
          Parallel.map(self.entries, options) { |val| block.call(val) }.each { |i| g.yield i }
        end)
      end
    end

    def each_concurrently(options={}, &block)
      Parallel.each(self.entries, options) { |val| block.call(val) }
    end

    def cycle
      Sequence.new(Sequence::Generator.new do |g|
        self.entries.cycle.each { |i| g.yield i }
      end)
    end

    protected

    def sequence
      Sequence.new(self)
    end

    def blank?(item)
      item.respond_to?(:empty?) ? item.empty? : !item
    end

    def serializer(container, entries)
      entries.each do |entry|
        if entry.is_a?(Sequences::Sequence)
          data = []
          serializer(data, entry)
          container << {type: :sequence, values: data}
        elsif entry.is_a?(Pair::Pair)
          if entry.second.is_a?(Sequences::Sequence)
            data = []
            serializer(data, entry)
            container << {type: :pair, values: data}
          else
            container << {type: :pair, values: entry.to_map}
          end
        elsif entry.is_a?(Option::Some)
          container << {type: :some, values: entry.value}
        elsif entry.is_a?(Option::None)
          container << {type: :none, values: nil}
        elsif entry.respond_to?(:each)
          data = []
          serializer(data, entry)
          container << {type: entry.class, values: data}
        else
          container << entry
        end
      end
    end

    def deserializer(container, data)
      data.each do |entry|
        if entry.is_a?(Hash)
          if entry[:type] == :sequence
            data = []
            deserializer(data, entry[:values])
            container << Sequence.new(data)
          elsif entry[:type] == :pair
            if entry[:values].is_a?(Array)
              container << pair(entry[:values].first, Sequence.new(entry[:values][1][:values]))
            else
              container << pair(entry[:values].keys.first, entry[:values].values.first)
            end
          elsif entry[:type] == :some
            container << some(entry[:values])
          elsif entry[:type] == :none
            container << none
          elsif entry[:type] == Hash
            h = entry[:values].map { |e| [e[:values]].to_h }.reduce({}) { |a, b| a.merge(b) }
            container << h
          else
            container << entry[:type].send(:new, entry[:values])
          end
        else
          container << entry
        end
      end
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















