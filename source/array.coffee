{isArray, extend} = _

nativeSplice = Array::splice
nativeSlice  = Array::slice

insertAt = (container, items, pos) ->
  collection = isArray(items) and items.length > 1
  if collection
    nativeSplice.apply(container, [pos, 0].concat(items))
  else
    nativeSplice.call(container, pos, 0, items[0] or items)

replaceAll = (container, items) ->
  if items and items.length
    nativeSplice.apply(container, [0, container.length].concat(items))
  else
    nativeSplice.call(container, 0, container.length)

removeAt = (container, pos, num = 1) ->
  nativeSplice.call(container, pos, num)

_.mixin {insertAt, replaceAll, removeAt, nativeSlice, nativeSplice}