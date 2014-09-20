module Any

  module_function

  def string(length=rand(10)+1)
    (0...length).map { ('a'..'z').to_a[rand(26)] }.join
  end

  # def any_int(length=rand(10))
  #   Seq.iterate(:+,1,length).map{ ('a'..'z').to_a[rand(26)] }
  # end

end