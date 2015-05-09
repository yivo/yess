traverseObject = (obj, path) ->
  ret = obj
  len = path.length
  i   = -1
  j   = 0

  while ++i <= len
    if i is len or path[i] is '.'
      if j > 0
        ret = ret[path[i - j...i]]
        unless ret?
          return ret
        j = 0
    else ++j
  if ret isnt obj
    ret

createObject = ->
  obj = {}
  i = -1
  len = arguments.length
  while (i += 2) < len
    obj[arguments[i - 1]] = arguments[i]
  obj

_.mixin {traverseObject, createObject}