module Maps

  module_function

 def merge(sequence_of_maps)
   sequence_of_maps.reduce({}){|a,b| a.merge(b) }
 end

end