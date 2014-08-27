class WhereProcessor
  def initialize(value)
    @value = value
  end

  def apply(predicates, invert=false)
    p predicates.to_a
    if invert
      @value if predicates.map { |x| x.value.call(@value, x.key) }.contains?(nil)
    else
      @value unless predicates.map { |x| x.value.call(@value, x.key) }.contains?(nil)
    end
  end
end