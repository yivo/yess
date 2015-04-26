{extend} = _

traverseObject = (obj, path) ->
  ret = obj
  len = path.length
  i = -1
  j = 0
  while ++i <= len
    if i is len or path[i] is '.'
      if j > 0
        ret = ret[path[i - j...i]]
        return ret unless ret
        j = 0
    else ++j
  if ret is obj then undefined else ret

createObject = ->
  obj = {}
  i = -1
  len = arguments.length
  while (i += 2) < len
    obj[arguments[i - 1]] = arguments[i]
  obj

extend yess, {traverseObject, createObject}