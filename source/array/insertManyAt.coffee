insertManyAt = (ary, items, pos) ->
  if (pos|0) <= ary.length
    ary.splice.apply(ary, [pos|0, 0].concat(items))
  ary
    
_.mixin {insertManyAt}
