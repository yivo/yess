do ->
  {keys} = _
  
  firstKey = (obj) ->
    _keys = keys(obj)
    _keys[0] if _keys.length > 0

  _.mixin {firstKey}, chain: false
