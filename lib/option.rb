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
      self.is_a?(Some)
    end

    def is_some?
      self.is_a?(None)
    end

    def get
      @content
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

    def get_or_throw(exception,message='')
      blank? ? raise(exception,message) : @content
    end

    def to_seq
      sequence(self)
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
      self.is_a?(Some)
    end

    def is_some?
      self.is_a?(None)
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

    def get_or_throw(exception,message='')
      raise(exception,message)
    end

    def to_seq
      sequence(self)
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

    protected

    def state
      @content
    end

  end


end