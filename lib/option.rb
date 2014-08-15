module Option

  def option(thing)
    thing.nil? ? none : some(thing)
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
      raise(Exception,'some cannot be nil') if @content.nil?
    end

    def <=>(object)
      self.state <=> object.state
    end

    def get
      @content
    end

    def value
      get
    end

    def empty?
      @content.empty?
    end

    def defined?
      !empty?
    end

    def get_or_else(item)
      blank? ? item : @content
    end

    def get_or_nil
      @content
    end

    def get_or_throw(exception)
      blank? ? @content : exception.call
    end

    def to_seq
      sequence(self)
    end

    def contains(item)
     value == item
    end

    def exists?(predicate)

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
      @content.nil? || @content.empty?
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

    protected

    def state
      @content
    end

  end


end