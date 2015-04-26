{isArray, extend} = _

splice = Array::splice
slice  = Array::slice

insertAt = (container, items, pos) ->
  many = isArray(items) and items.length > 1
  if many
    splice.apply container, [pos, 0].concat(items)
  else
    splice.call container, pos, 0, items[0] or items

replaceAll = (container, items) ->
  if items and items.length
    splice.apply container, [0, container.length].concat items
  else
    splice.call container, 0, container.length

removeAt = (container, pos, num = 1) ->
  splice.call container, pos, num

extend yess, {insertAt, replaceAll, removeAt, slice, splice}