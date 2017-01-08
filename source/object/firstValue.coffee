do ->
  {keys} = _

  firstValue = (obj) ->
    _keys = keys(obj)
    obj[_keys[0]] if _keys.length > 0

  _.mixin {firstValue}
