class WhereProcessor
  def initialize(value)
    @value = value
  end

  def apply(predicates)
    @value unless predicates.map { |x| x.value.call(@value, x.key) }.contains?(nil)
  end
end