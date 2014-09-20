module Any

  module_function

  def string(length=rand(10)+1)
    Seq.range('a','z').shuffle.take(length).to_a.join
  end

  def int(length=rand(10)+1)
    Seq.repeat(-> { rand(9)}).take(length).to_a.join.to_i
  end

end