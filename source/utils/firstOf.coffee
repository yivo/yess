do ->
  {keys}   = _
  isArray  = _.isArrayLike  ? _.isArray
  isObject = _.isObjectLike ? _.isObject

  firstOf = (arg) ->
    if isArray(arg)
      arg[0] if arg.length > 0

    else if isObject(arg)
      _keys = keys(arg)
      arg[_keys[0]] if _keys.length > 0

    else arg

  _.mixin {firstOf}
