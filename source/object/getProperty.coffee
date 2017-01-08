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
  
_.mixin {traverseObject, getProperty}
