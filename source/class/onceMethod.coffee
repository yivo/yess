do ->
  {once} = _
  
  onceMethod = (object, methods...) ->
    for method in methods
      object[method] = once(object[method])
    return
    
  _.mixin {onceMethod}, chain: false
