do ->
  {isArray, isObject, keys} = _

  insertManyAt = (ary, items, pos) ->
    if (pos|0) <= ary.length
      ary.splice.apply(ary, [pos|0, 0].concat(items))

  insertOneAt = (ary, item, pos) ->
    if (pos|0) <= ary.length
      ary.splice(pos|0, 0, item)

  insertAt = (ary, items, pos) ->
    if isArray(items)
      insertManyAt(ary, items, pos|0)
    else
      insertOneAt(ary, items, pos|0)

  replaceAll = (ary, items) ->
    if items?.length > 0
      ary.splice.apply(ary, [0, ary.length].concat(items))
    else
      ary.splice(0, ary.length)

  removeAt = (ary, pos, num) ->
    _num = num|0
    _num = 1 if _num is 0
    ary.splice(pos, _num) if pos > -1 and _num > 0 and (pos + _num) <= ary.length

  equalArrays = (array, other) ->
    if array is other
      return true

    if array.length isnt other.length
      return false

    for item, i in array
      if item isnt other[i]
        return false
    true

  inGroupsOf = (n, array, iteratee) ->
    groups = [] unless iteratee
    l = array.length
    i = -1
    while ++i < l
      j = 0
      group = []
      while (++j <= n) and (i + j - 1) < l
        group.push(array[i + j - 1])

      if iteratee
        iteratee(group, array)
      else
        groups.push(group) if group.length > 0
      i = i + j - 2
    if iteratee then undefined else groups

  firstOf = (arg) ->
    if isArray(arg)
      arg[0] if arg.length > 0

    else if isObject(arg)
      _keys = keys(arg)
      arg[_keys[0]] if _keys.length > 0

    else arg

  firstKey = (obj) ->
    _keys = keys(obj)
    _keys[0] if _keys.length > 0

  firstValue = (obj) ->
    _keys = keys(obj)
    obj[_keys[0]] if _keys.length > 0

  _.mixin {
    firstOf, firstKey, firstValue,

    insertAt, insertOneAt, insertManyAt,

    replaceAll, removeAt,

    equalArrays, inGroupsOf
  }
