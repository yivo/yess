{isArray}    = _
nativeSplice = Array::splice
nativeSlice  = Array::slice

insertManyAt = (container, items, pos) ->
  if items.length
    nativeSplice.apply(container, [pos, 0].concat(items))

insertOneAt = (container, item, pos) ->
  nativeSplice.call(container, pos, 0, item)

insertAt = (container, items, pos) ->
  if isArray(items)
    insertManyAt(container, items, pos)
  else
    insertOneAt(container, items, pos)

replaceAll = (container, items) ->
  if items and items.length
    nativeSplice.apply(container, [0, container.length].concat(items))
  else
    nativeSplice.call(container, 0, container.length)

removeAt = (container, pos, num = 1) ->
  nativeSplice.call(container, pos, num)

equalArrays = (array, other) ->
  if array is other
    return true

  if array.length isnt other.length
    return false

  for item, i in array
    if item isnt other[i]
      return false
  true

_.mixin {insertAt, insertOneAt, insertManyAt, replaceAll, removeAt, equalArrays, nativeSlice, nativeSplice}