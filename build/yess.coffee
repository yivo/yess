###!
# fn-focusring 1.0.11 | https://github.com/yivo/fn-focusring | MIT License
###

((factory) ->

  __root__ = 
    # The root object for Browser or Web Worker
    if typeof self is 'object' and self isnt null and self.self is self
      self

    # The root object for Server-side JavaScript Runtime
    else if typeof global is 'object' and global isnt null and global.global is global
      global

    else
      Function('return this')()

  # Asynchronous Module Definition (AMD)
  if typeof define is 'function' and typeof define.amd is 'object' and define.amd isnt null
    define ['lodash'], (_) ->
      __root__._ = factory(__root__, Object, Array, Number, String, Boolean, _)

  # Server-side JavaScript Runtime compatible with CommonJS Module Spec
  else if typeof module is 'object' and module isnt null and typeof module.exports is 'object' and module.exports isnt null
    module.exports = factory(__root__, Object, Array, Number, String, Boolean, require('lodash'))

  # Browser, Web Worker and the rest
  else
    __root__._ = factory(__root__, Object, Array, Number, String, Boolean, _)

  # No return value
  return

)((__root__, Object, Array, Number, String, Boolean, _) ->
  equalArrays = (array, other) ->
    if array is other
      return true
  
    if array.length isnt other.length
      return false
  
    for item, i in array
      if item isnt other[i]
        return false
    true
    
  _.mixin {equalArrays}, chain: false
  
  inGroupsOf = (n, array, iteratee) ->
    groups = []
    l = array.length
    i = -1
    while ++i < l
      j = 0
      group = []
      while (++j <= n) and (i + j - 1) < l
        group.push(array[i + j - 1])
      iteratee?(group, array)
      groups.push(group) if group.length > 0
      i = i + j - 2
    groups
    
  _.mixin {inGroupsOf}, chain: false
  
  insertOneAt = (ary, item, pos) ->
    if (pos|0) <= ary.length
      ary.splice(pos|0, 0, item)
    ary
    
  _.mixin {insertOneAt}, chain: false
  
  insertManyAt = (ary, items, pos) ->
    if (pos|0) <= ary.length
      ary.splice.apply(ary, [pos|0, 0].concat(items))
    ary
      
  _.mixin {insertManyAt}, chain: false
  
  do ->
    {isArray, insertOneAt, insertManyAt} = _
    
    insertAt = (ary, items, pos) ->
      if isArray(items)
        insertManyAt(ary, items, pos|0)
      else
        insertOneAt(ary, items, pos|0)
      ary
        
    _.mixin {insertAt}, chain: false
  
  removeAt = (ary, pos, num) ->
    _num = num|0
    _num = 1 if _num is 0
    ary.splice(pos, _num) if pos > -1 and _num > 0 and (pos + _num) <= ary.length
  
  _.mixin {removeAt}, chain: false
  
  replaceAll = (ary, items) ->
    if items?.length > 0
      ary.splice.apply(ary, [0, ary.length].concat(items))
    else
      ary.splice(0, ary.length)
  
  _.mixin {replaceAll}, chain: false
  
    
  do ->
    {bind} = _
    
    bindMethod = (object, methods...) ->
      for method in methods
        object[method] = bind(object[method], object)
      return
      
    _.mixin {bindMethod}, chain: false
  
  do ->
    {debounce} = _
    
    debounceMethod = (object, method, time, options) ->
      object[method] = debounce(object[method], time, options)
  
    _.mixin {debounceMethod}, chain: false
  
  _.mixin({isClass: _.isFunction}, chain: false)
  
  do ->
    {isFunction} = _
    
    mapMethod = (object, method) ->
      if isFunction(method)
        method
      else
        object?[method]
  
    _.mixin {mapMethod}, chain: false
  
  do ->
    {once} = _
    
    onceMethod = (object, methods...) ->
      for method in methods
        object[method] = once(object[method])
      return
      
    _.mixin {onceMethod}, chain: false
  
  do ->
    {extend} = _
  
    privatizeSuperclass = (Class) ->
      if Class.__super__? and not Class.__superclassPrivatized__
        
        if Object.create?
          copy = Object.create(Class.__super__)
        else
          copy = extend({}, Class.__super__)
          ctor = -> @constructor = copy
          ctor.prototype = Class.__super__.prototype
          copy.prototype = new ctor()
  
        copy.constructor = Class.__super__.constructor
  
        Class.__superclassPrivatized__ = true
        Class.__super__                = copy
      return
      
    _.mixin {
      privatizeSuperclass,
      
      # COMPATIBILITY: This is old name
      copySuper: privatizeSuperclass
    }, chain: false
  
  
  # _.createObject('foo', 'bar', 'baz', 'qux') => { foo: 'bar', baz: 'qux' }
  createObject = ->
    obj = {}
    idx = -1
    len = arguments.length
    while (idx += 2) < len
      obj[arguments[idx - 1]] = arguments[idx]
    obj
  
  _.mixin {createObject}, chain: false
  
  do ->
    {keys} = _
    
    firstKey = (obj) ->
      _keys = keys(obj)
      _keys[0] if _keys.length > 0
  
    _.mixin {firstKey}, chain: false
  
  do ->
    {keys} = _
  
    firstValue = (obj) ->
      _keys = keys(obj)
      obj[_keys[0]] if _keys.length > 0
  
    _.mixin {firstValue}, chain: false
  
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
    
  _.mixin {traverseObject, getProperty}, chain: false
  
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
  
  _.mixin {setProperty}, chain: false
  
  do ->
    {keys} = _
  
    keyval = (obj) ->
      _keys = keys(obj)
      [_keys[0], obj[_keys[0]]] if _keys.length > 0
  
    _.mixin {keyval}, chain: false
  
  
  # http://jsperf.com/apply-vs-custom-apply
  exec = (func, context, args) ->
    switch args.length
      when 0 then func.call(context)
      when 1 then func.call(context, args[0])
      when 2 then func.call(context, args[0], args[1])
      when 3 then func.call(context, args[0], args[1], args[2])
      else func.apply(context, args)
  
  _.mixin {exec}, chain: false
  
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
  
    _.mixin {firstOf}, chain: false
  
  generateID = do ->
    n = 0
    -> ++n
  
  _.mixin {generateID}, chain: false
  
  NATIVES = [Object, Array, Number, String, Boolean]
  
  Object.freeze?(NATIVES)
  
  # http://stackoverflow.com/questions/23570355/how-to-determine-if-variable-was-instantiated-using-new
  isConstructed = (object) ->
    object? and object.constructor not in NATIVES
  
  _.mixin {
    isConstructed,
  
    # COMPATIBILITY: This is old name
    wasConstructed: isConstructed
  }, chain: false
  
  isEnabled = (options, optionname) ->
    options isnt false and options?[optionname] isnt false
  
  _.mixin {isEnabled}, chain: false
  
  
  _
)