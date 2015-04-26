((root, factory) ->
  if typeof define is 'function' and define.amd
    define(['lodash'], factory)
  else if typeof module is 'object' && typeof module.exports is 'object'
    module.exports = factory(require('lodash'))
  else
    root.yess = factory(root._)
)(@, (_) ->

  yess = {}
  
  {isArray, extend} = _
  
  splice = Array::splice
  slice  = Array::slice
  
  insertAt = (container, items, pos) ->
    many = isArray(items) and items.length > 1
    if many
      splice.apply container, [pos, 0].concat(items)
    else
      splice.call container, pos, 0, items[0] or items
  
  replaceAll = (container, items) ->
    if items and items.length
      splice.apply container, [0, container.length].concat items
    else
      splice.call container, 0, container.length
  
  removeAt = (container, pos, num = 1) ->
    splice.call container, pos, num
  
  extend yess, {insertAt, replaceAll, removeAt, slice, splice}
  {isFunction, extend} = _
  
  lodashBind     = _.bind
  lodashDebounce = _.debounce
  
  # @see http://jsperf.com/apply-vs-custom-apply
  apply = (func, obj, args) ->
    arg1 = args[0]
    arg2 = args[1]
    arg3 = args[2]
    switch args.length
      when 0 then func.call(obj)
      when 1 then func.call(obj, arg1)
      when 2 then func.call(obj, arg1, arg2)
      when 3 then func.call(obj, arg1, arg2, arg3)
      else func.apply(obj, args)
  
  mapMethod = (object, method) ->
    if isFunction(method) then method else object and object[method]
  
  debounce = (object, method, time, options) ->
    object[method] = lodashDebounce(lodashBind(object[method], object), time, options)
  
  bind = (object, methods...) ->
    for method in methods
      object[method] = lodashBind(object[method], object)
    return
  
  once = (object, methods...) ->
    for method in methods
      real = object[method]
  
      wrapper = do (object, real) ->
        run = no
        memo = undefined
        ->
          unless run
            run = yes
            memo = real.apply(object, arguments)
  
            # Break references!
            object = null
            real = null
          memo
  
      object[method] = wrapper
    return
  
  extend yess, {apply, once, bind, debounce, mapMethod}
  {extend} = _
  
  traverseObject = (obj, path) ->
    ret = obj
    len = path.length
    i = -1
    j = 0
    while ++i <= len
      if i is len or path[i] is '.'
        if j > 0
          ret = ret[path[i - j...i]]
          return ret unless ret
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
  
  extend yess, {traverseObject, createObject}
  {extend, uniqueId} = _
  
  isEnabled = (options, option) ->
    not options or options[option] is undefined or !!options[option]
  
  generateId = -> +uniqueId()
  
  extend yess, {isEnabled, generateId}
  
  yess
)
