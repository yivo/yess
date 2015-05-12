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
  {isArray}    = _
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
    for name in methods
      method = object[name]
  
      wrapper = do (object, method) ->
        run  = no
        memo = undefined
        ->
          unless run
            run  = yes
            memo = method.apply(object, arguments)
  
            # Break references!
            object = method = null
          memo
  
      object[name] = wrapper
    return
  
  _.mixin {applyWith, onceMethod, bindMethod, debounceMethod, mapMethod}
  createObject = ->
    obj = {}
    i = -1
    len = arguments.length
    while (i += 2) < len
      obj[arguments[i - 1]] = arguments[i]
    obj
  
  traverseObject = getProperty = (obj, path) ->
    ret  = obj
    len  = path.length
    i    = -1
    j    = 0
  
    while ++i <= len and ret?
      if i is len or path[i] is '.'
        if j > 0
          ret = ret[path[i - j...i]]
          unless ret?
            return ret
          j = 0
      else ++j
  
    if ret isnt obj
      ret
  
  setProperty = (obj, path, val, expand = yes) ->
    now = obj
    len = path.length
    i   = -1
    j   = 0
  
    while ++i <= len
      if i is len or path[i] is '.'
        if j > 0
          before = now
          if prop and !(now = before[prop])?
            return no unless expand
            now = before[prop] = {}
          prop   = path[i - j...i]
          j      = 0
      else ++j
  
    if prop
      now[prop] = val
  
    obj
  
  _.mixin {createObject, traverseObject, setProperty, getProperty}
  {extend, uniqueId} = _
  
  isEnabled = (options, option) ->
    !options or options[option] is undefined or !!options[option]
  
  generateId = -> +uniqueId()
  
  _.mixin {isEnabled, generateId}
  eachToken = (str, callback) ->
    len = str.length
    i   = -1
    j   = 0
    while ++i <= len
      if i is len or str[i] is ' '
        if j > 0
          callback(str[i - j...i], str)
        j = 0
      else ++j
    return
  
  _.mixin {eachToken}
  {extend} = _
  
  overrideConstructor = (original, overrides, type = 'before') ->
    prototype = original.prototype
  
    overridden = if type is 'before'
      ->
        overrides.apply(this, arguments)
        original.apply(this, arguments)
        this
  
    else if type is 'after'
      ->
        original.apply(this, arguments)
        overrides.apply(this, arguments)
        this
  
    else if type is 'instead'
      ->
        overrides.apply(this, arguments)
        this
  
    # Migrate class members
    extend(overridden, original);
  
    # Migrate prototype
    overridden.prototype = prototype
    overridden.prototype.constructor = overridden
    overridden
  
  beforeConstructor = (original, overrides) ->
    overrideConstructor(original, overrides, 'before')
  
  afterConstructor = (original, overrides) ->
    overrideConstructor(original, overrides, 'after')
  
  insteadConstructor = (original, overrides) ->
    overrideConstructor(original, overrides, 'instead')
  
  _.mixin {overrideConstructor, beforeConstructor, afterConstructor, insteadConstructor}
  return
)