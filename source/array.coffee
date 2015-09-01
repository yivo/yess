do ->
  {isArray}    = _
  nativeSplice = Array::splice
  nativeSlice  = Array::slice
  nativeSort   = Array::sort

  insertManyAt = (array, items, pos) ->
    if items.length
      nativeSplice.apply(array, [pos, 0].concat(items))

  insertOneAt = (array, item, pos) ->
    nativeSplice.call(array, pos, 0, item)

  insertAt = (array, items, pos) ->
    if isArray(items)
      insertManyAt(array, items, pos)
    else
      insertOneAt(array, items, pos)

  replaceAll = (array, items) ->
    if items and items.length
      nativeSplice.apply(array, [0, array.length].concat(items))
    else
      nativeSplice.call(array, 0, array.length)

  removeAt = (array, pos, num) ->
    _num = 1 unless num?
    if pos > -1 and _num > 0 and (pos + _num) <= array.length
      nativeSplice.call(array, pos, _num)

  equalArrays = (array, other) ->
    if array is other
      return true

    if array.length isnt other.length
      return false

    for item, i in array
      if item isnt other[i]
        return false
    true

  _.mixin {
    insertAt, insertOneAt, insertManyAt,
    replaceAll, removeAt,
    equalArrays,
    nativeSlice, nativeSplice, nativeSort
  }