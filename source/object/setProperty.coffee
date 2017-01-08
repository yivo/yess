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

_.mixin {setProperty}
