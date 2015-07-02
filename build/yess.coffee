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
  nativeSort   = Array::sort
  
  insertManyAt = (array, items, pos) ->
    if items.length
      nativeSplice.apply(array, [pos, 0].concat(items))
  
  insertOneAt = (array, item, pos) ->
    nativeSplice.call(array, pos, 0, item)
  
  insertAt = (array, items, pos) ->
    if isArray(items)
      insertManyAt(array, items, pos)
    else
      insertOneAt(array, items, pos)
  
  replaceAll = (array, items) ->
    if items and items.length
      nativeSplice.apply(array, [0, array.length].concat(items))
    else
      nativeSplice.call(array, 0, array.length)
  
  removeAt = (array, pos, num = 1) ->
    if pos > -1 and num > 0 and (pos + num) <= array.length
      nativeSplice.call(array, pos, num)
  
  equalArrays = (array, other) ->
    if array is other
      return true
  
    if array.length isnt other.length
      return false
  
    for item, i in array
      if item isnt other[i]
        return false
    true
  
  _.mixin {
    insertAt, insertOneAt, insertManyAt,
    replaceAll, removeAt,
    equalArrays,
    nativeSlice, nativeSplice, nativeSort
  }
  {isFunction, extend} = _
  
  lodashBind     = _.bind
  lodashDebounce = _.debounce
  lodashOnce     = _.once
  
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
    object[method] = lodashDebounce(object[method], time, options)
  
  bindMethod = (object, methods...) ->
    for method in methods
      object[method] = lodashBind(object[method], object)
    return
  
  onceMethod = (object, methods...) ->
    for method in methods
      object[method] = lodashOnce(object[method])
    return
  
  # http://stackoverflow.com/questions/23570355/how-to-determine-if-variable-was-instantiated-using-new
  wasConstructed = (obj) ->
    obj.constructor not in [Object, Array, Number, String, Boolean]
  
  _.mixin {applyWith, onceMethod, bindMethod, debounceMethod, mapMethod, wasConstructed}
  createObject = ->
    obj = {}
    i   = -1
    len = arguments.length
    while (i += 2) < len
      obj[arguments[i - 1]] = arguments[i]
    obj
  
  traverseObject = getProperty = (obj, path) ->
    _obj = obj
    len  = path.length
    i    = -1
    j    = 0
  
    while ++i <= len and _obj?
      if i is len or path[i] is '.'
        if j > 0
          prop = path[i - j...i]
          _obj = _obj[prop]
          return _obj if not _obj?
          j = 0
      else ++j
  
    _obj if i > 0
  
  setProperty = (obj, path, val) ->
    now = obj
    len = path.length
    i   = -1
    j   = 0
  
    while ++i <= len
      if i is len or path[i] is '.'
        if j > 0
          before = now
          if prop and !(now = before[prop])?
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
  
  overrideFunction = (original, overrides, type = 'before') ->
    ->
      switch type
        when 'before'
          overrides.apply(this, arguments)
          ret = original.apply(this, arguments)
        when 'after'
          ret = original.apply(this, arguments)
          overrides.apply(this, arguments)
      ret
  
  overrideMethod = (object, method, overrides, type) ->
    object[method] = overrideFunction(object[method], overrides, type)
  
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
  
  beforeFunction = (original, overrides) ->
    overrideFunction(original, overrides, 'before')
  
  afterFunction = (original, overrides) ->
    overrideFunction(original, overrides, 'after')
  
  beforeMethod = (object, method, overrides) ->
    overrideMethod(object, method, overrides, 'before')
  
  afterMethod = (object, method, overrides) ->
    overrideMethod(object, method, overrides, 'after')
  
  copySuper = (obj) ->
    if obj.superCopier isnt obj
      if obj.__super__
        copy = extend({}, obj.__super__)
        copy.constructor = obj.__super__.constructor
        obj.__super__ = copy
      else
        obj.__super__ = {}
      obj.superCopier = obj
    obj.__super__
  
  _.mixin {
    overrideConstructor
    overrideFunction
    overrideMethod
    beforeConstructor
    afterConstructor
    insteadConstructor
    beforeFunction
    afterFunction
    beforeMethod
    afterMethod
    copySuper
    isClass: _.isFunction
  }
  return
)