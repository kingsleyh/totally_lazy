module Option

  def option(thing)
    validate = thing.respond_to?(:empty?) ? thing.empty? : !thing
    validate ? none : some(thing)
  end

  def some(thing)
    Some.new(thing)
  end

  def none(thing=nil)
    None.new(thing)
  end

  class Some

    include Comparable

    def initialize(content)
      @content = content
      raise(Exception, 'some cannot be nil') if @content.nil?
    end


    def <=>(object)
      self.state <=> object.state
    end

    def is_none?
      self.is_a?(None)
    end

    def is_some?
      self.is_a?(Some)
    end

    def get
      @content
    end

    def head_option
      as_option(sequence(@content))
    end

    def value
      get
    end

    def empty?
      blank?
    end

    def defined?
      !blank?
    end

    def get_or_else(item)
      blank? ? item : @content
    end

    def get_or_nil
      blank? ? nil : @content
    end

    def get_or_throw(exception, message='')
      blank? ? raise(exception, message) : @content
    end

    def to_seq
      sequence(get)
    end

    def contains(item)
      value == item
    end

    def exists?(predicate)
      value
    end

    def join(target_sequence)
      sequence(value) << target_sequence
    end

    def each(&block)
      @content.each(&block)
    end

    def map(predicate=nil, &block)
      as_option(sequence(@content).map(predicate, &block))
    end

    alias collect map

    def select(predicate=nil, &block)
      as_option(sequence(@content).select(predicate, &block))
    end

    alias find_all select
    alias filter select

    def reject(predicate=nil, &block)
      as_option(sequence(@content).reject(predicate, &block))
    end

    alias unfilter reject

    def grep(pattern)
      as_option(sequence(@content).grep(pattern))
    end

    def drop(n)
      as_option(sequence(@content).drop(n))
    end

    def drop_while(&block)
      as_option(@content.drop_while(&block))
    end

    def take(n)
      as_option(sequence(@content).take(n))
    end

    def take_while(&block)
      as_option(@content.take_while(&block))
    end

    def flat_map(&block)
      as_option(sequence(@content).flat_map(&block))
    end

    alias collect_concat flat_map

    # TODO - fix me
    # def zip(*args, &block)
    #   sequence(@content).zip(*args,&block).head_option
    # end

    alias + join
    alias << join

    protected
    def state
      @content
    end

    private

    def blank?
      @content.respond_to?(:empty?) ? @content.empty? : !@content
    end

    def as_option(seq)
      seq.count == 1 ? seq.head_option : option(seq.entries)
    end

  end

  class None

    include Comparable

    def initialize(content)
      @content = content
    end

    def <=>(object)
      self.state <=> object.state
    end

    def is_none?
      self.is_a?(None)
    end

    def is_some?
      self.is_a?(Some)
    end

    def get
      raise NoSuchElementException.new, 'The option was empty'
    end

    def value
      raise NoSuchElementException.new, 'The option was empty'
    end

    def empty?
      true
    end

    def defined?
      false
    end

    def get_or_else(item)
      item
    end

    def get_or_nil
      nil
    end

    def get_or_throw(exception, message='')
      raise(exception, message)
    end

    def to_seq
      empty
    end

    def to_seq1
      empty
    end

    def each(&block)
      empty
    end

    def contains(item)
      false
    end

    def exists?(predicate)
      false
    end

    def join(target_sequence)
      target_sequence.is_a?(Sequences::Sequence) ? target_sequence : sequence(target_sequence)
    end

    alias + join
    alias << join

    def map(predicate=nil, &block)
      none
    end

    alias collect map

    def select(predicate=nil, &block)
      none
    end

    alias find_all select
    alias filter select

    def reject(predicate=nil, &block)
      none
    end

    alias unfilter reject

    def grep(pattern)
      none
    end

    def drop(n)
      none
    end

    def drop_while(&block)
      none
    end

    def take(n)
      none
    end

    def take_while(&block)
      none
    end

    def flat_map(&block)
      none
    end

    def head_option
      none
    end

    alias collect_concat flat_map

    protected

    def state
      @content
    end

  end


end
