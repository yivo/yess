do ->
  {debounce} = _
  
  debounceMethod = (object, method, time, options) ->
    object[method] = debounce(object[method], time, options)

  _.mixin {debounceMethod}
