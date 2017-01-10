do ->
  {keys} = _

  keyval = (obj) ->
    _keys = keys(obj)
    [_keys[0], obj[_keys[0]]] if _keys.length > 0

  _.mixin {keyval}, chain: false
