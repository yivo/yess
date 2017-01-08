do ->
  {isFunction} = _
  
  mapMethod = (object, method) ->
    if isFunction(method)
      method
    else
      object?[method]

  _.mixin {mapMethod}
