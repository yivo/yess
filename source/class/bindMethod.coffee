do ->
  {bind} = _
  
  bindMethod = (object, methods...) ->
    for method in methods
      object[method] = bind(object[method], object)
    return
    
  _.mixin {bindMethod}, chain: false
