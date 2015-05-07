((root, factory) ->
  if typeof define is 'function' and define.amd
    define ['lodash'], (_) ->
      factory(root, _)
  else if typeof module is 'object' && typeof module.exports is 'object'
    factory(root, require('lodash'))
  else
    factory(root, root._)
  return
)(this, (root, _) ->
  {isArray, extend} = _
  
  nativeSplice = Array::splice
  nativeSlice  = Array::slice
  
  insertAt = (container, items, pos) ->
    collection = isArray(items) and items.length > 1
    if collection
      nativeSplice.apply(container, [pos, 0].concat(items))
    else
      nativeSplice.call(container, pos, 0, items[0] or items)
  
  replaceAll = (container, items) ->
    if items and items.length
      nativeSplice.apply(container, [0, container.length].concat(items))
    else
      nativeSplice.call(container, 0, container.length)
  
  removeAt = (container, pos, num = 1) ->
    nativeSplice.call(container, pos, num)
  
  _.mixin {insertAt, replaceAll, removeAt, nativeSlice, nativeSplice}
  {isFunction, extend} = _
  
  lodashBind     = _.bind
  lodashDebounce = _.debounce
  
  # @see http://jsperf.com/apply-vs-custom-apply
  applyWith = (func, context, args) ->
    arg1 = args[0]
    arg2 = args[1]
    arg3 = args[2]
    switch args.length
      when 0 then func.call(context)
      when 1 then func.call(context, arg1)
      when 2 then func.call(context, arg1, arg2)
      when 3 then func.call(context, arg1, arg2, arg3)
      else func.apply(context, args)
  
  mapMethod = (object, method) ->
    if isFunction(method)
      method
    else
      object and object[method]
  
  debounceMethod = (object, method, time, options) ->
    object[method] = lodashDebounce(lodashBind(object[method], object), time, options)
  
  bindMethod = (object, methods...) ->
    for method in methods
      object[method] = lodashBind(object[method], object)
    return
  
  onceMethod = (object, methods...) ->
    for method in methods
      method = object[method]
  
      wrapper = do (object, method) ->
        run = no
        memo = undefined
        ->
          unless run
            run = yes
            memo = method.apply(object, arguments)
  
            # Break references!
            object = method = null
          memo
  
      object[method] = wrapper
    return
  
  _.mixin {applyWith, onceMethod, bindMethod, debounceMethod, mapMethod}
  traverseObject = (obj, path) ->
    ret = obj
    len = path.length
    i   = -1
    j   = 0
  
    while ++i <= len
      if i is len or path[i] is '.'
        if j > 0
          ret = ret[path[i - j...i]]
          return ret unless ret # TODO Check own property or by != null ?
          j = 0
      else ++j
    if ret is obj then undefined else ret
  
  createObject = ->
    obj = {}
    i = -1
    len = arguments.length
    while (i += 2) < len
      obj[arguments[i - 1]] = arguments[i]
    obj
  
  _.mixin {traverseObject, createObject}
  {extend, uniqueId} = _
  
  isEnabled = (options, option) ->
    !options or options[option] is undefined or !!options[option]
  
  generateId = -> +uniqueId()
  
  _.mixin {isEnabled, generateId}
  return
)