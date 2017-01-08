insertOneAt = (ary, item, pos) ->
  if (pos|0) <= ary.length
    ary.splice(pos|0, 0, item)
  ary
  
_.mixin {insertOneAt}
