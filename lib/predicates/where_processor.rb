class WhereProcessor
  def initialize(value)
    @value = value
  end

  def apply(ands, ors)
    if ors.empty?
      @value unless ands.map { |x| x.value.call(@value, x.key) }.contains?(nil)
    else
      @value unless ors.map { |x| x.value.call(@value, x.key) }.drop_nil.empty?
    end
  end
end