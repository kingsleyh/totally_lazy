module Option

  class Some

    include Comparable

    def initialize(content)
      @content = content
    end

    def <=>(object)
      self.state <=> object.state
    end

    def get
      @content
    end

    def get_or_else(item)
      @content.nil? ? item : @content
    end

    def get_or_nil
      @content
    end

    def is_empty?
      @content.empty?
    end

    protected
    def state
      @content
    end

  end

  class None

    include Comparable

    def initialize(content='')
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

  def some(item)
    Some.new(item)
  end

  def none
    None.new
  end

end