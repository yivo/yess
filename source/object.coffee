createObject = ->
  obj = {}
  i   = -1
  len = arguments.length
  while (i += 2) < len
    obj[arguments[i - 1]] = arguments[i]
  obj

traverseObject = getProperty = (obj, path) ->
  _obj = obj
  len  = path.length
  i    = -1
  j    = 0

  while ++i <= len and _obj?
    if i is len or path[i] is '.'
      if j > 0
        prop = path[i - j...i]
        _obj = _obj[prop]
        return _obj if not _obj?
        j = 0
    else ++j

  _obj if i > 0

setProperty = (obj, path, val) ->
  now = obj
  len = path.length
  i   = -1
  j   = 0

  while ++i <= len
    if i is len or path[i] is '.'
      if j > 0
        before = now
        if prop and !(now = before[prop])?
          now = before[prop] = {}
        prop   = path[i - j...i]
        j      = 0
    else ++j

  if prop
    now[prop] = val

  obj

_.mixin {createObject, traverseObject, setProperty, getProperty}