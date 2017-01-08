do ->
  {isArray, insertOneAt, insertManyAt} = _
  
  insertAt = (ary, items, pos) ->
    if isArray(items)
      insertManyAt(ary, items, pos|0)
    else
      insertOneAt(ary, items, pos|0)
    ary
      
  _.mixin {insertAt}
