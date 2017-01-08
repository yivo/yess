equalArrays = (array, other) ->
  if array is other
    return true

  if array.length isnt other.length
    return false

  for item, i in array
    if item isnt other[i]
      return false
  true
  
_.mixin {equalArrays}
