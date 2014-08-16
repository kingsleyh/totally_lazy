class Type

  def self.check(actual, expected)
    raise(UnsupportedTypeException.new, "Target must be of type: #{expected} but was: #{actual.class}") unless actual.kind_of?(expected)
  end

  def self.responds(value,meth)
    raise(UnsupportedTypeException.new, "Target must respond to: #{meth} - but did not with: #{value.class} of: #{value}") unless value.respond_to?(meth)
  end

end