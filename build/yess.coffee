((factory) ->

  # Browser and WebWorker
  root = if typeof self is 'object' and self?.self is self
    self

  # Server
  else if typeof global is 'object' and global?.global is global
    global

  # AMD
  if typeof define is 'function' and define.amd
    define ['lodash', 'exports'], (_) ->
      factory(root, _)

  # CommonJS
  else if typeof module is 'object' and module isnt null and
          module.exports? and typeof module.exports is 'object'
    factory(root, require('lodash'))

  # Browser and the rest
  else
    factory(root, root._)

  # No return value
  return

)((__root__, _) ->
  do ->
    {isArray, isObject, keys} = _
  
    insertManyAt = (ary, items, pos) ->
      if (pos|0) <= items.length
        ary.splice.apply(ary, [pos|0, 0].concat(items))
  
    insertOneAt = (ary, item, pos) ->
      if (pos|0) <= items.length
        ary.splice(pos|0, 0, item)
  
    insertAt = (ary, items, pos) ->
      if isArray(items)
        insertManyAt(ary, items, pos|0)
      else
        insertOneAt(ary, items, pos|0)
  
    replaceAll = (ary, items) ->
      if items?.length > 0
        ary.splice.apply(ary, [0, ary.length].concat(items))
      else
        ary.splice(0, ary.length)
  
    removeAt = (ary, pos, num) ->
      _num = num|0
      _num = 1 if _num is 0
      ary.splice(pos, _num) if pos > -1 and _num > 0 and (pos + _num) <= ary.length
  
    equalArrays = (array, other) ->
      if array is other
        return true
  
      if array.length isnt other.length
        return false
  
      for item, i in array
        if item isnt other[i]
          return false
      true
  
    inGroupsOf = (n, array, iteratee) ->
      groups = [] unless iteratee
      l = array.length
      i = -1
      while ++i < l
        j = 0
        group = []
        while (++j <= n) and (i + j - 1) < l
          group.push(array[i + j - 1])
  
        if iteratee
          iteratee(group, array)
        else
          groups.push(group) if group.length > 0
        i = i + j - 2
      if iteratee then undefined else groups
  
    firstOf = (arg) ->
      if isArray(arg)
        arg[0] if arg.length > 0
  
      else if isObject(arg)
        _keys = keys(arg)
        arg[_keys[0]] if _keys.length > 0
  
      else arg
  
    firstKey = (obj) ->
      _keys = keys(obj)
      _keys[0] if _keys.length > 0
  
    firstValue = (obj) ->
      _keys = keys(obj)
      obj[_keys[0]] if _keys.length > 0
  
    _.mixin {
      firstOf, firstKey, firstValue,
  
      insertAt, insertOneAt, insertManyAt,
  
      replaceAll, removeAt,
  
      equalArrays, inGroupsOf
    }
  
  do ->
    {isFunction} = _
  
    lodashBind     = _.bind
    lodashDebounce = _.debounce
    lodashOnce     = _.once
  
    # @see http://jsperf.com/apply-vs-custom-apply
    applyWith = (func, context, args) ->
      length  = args.length
      arg1    = args[0] if length > 0
      arg2    = args[1] if length > 1
      arg3    = args[2] if length > 2
      switch length
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
  
    _.mixin {applyWith, onceMethod, bindMethod, debounceMethod, mapMethod}
  do ->
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
  do ->
    isEnabled = (options, key) ->
      options isnt false and options?[key] isnt false
  
    generateID = do ->
      n = 0
      -> ++n
  
    _.mixin {isEnabled, generateID}
  
  do ->
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
  do ->
    {extend} = _
  
    overrideFunction = (original, overrides, type) ->
      _overrides = overrides
      _original  = original
      ->
        switch type ? 'before'
          when 'before'
            _overrides.apply(this, arguments)
            ret = _original.apply(this, arguments)
          when 'after'
            ret = _original.apply(this, arguments)
            _overrides.apply(this, arguments)
        ret
  
    overrideMethod = (object, method, overrides, type) ->
      object[method] = overrideFunction(object[method], overrides, type)
  
    overrideConstructor = (original, overrides, type) ->
      # Don't lock arguments in closures. Lock local variables instead
      _original  = original
      _overrides = overrides
      prototype  = _original.prototype
  
      overridden = if not type? or type is 'before'
        ->
          _overrides.apply(this, arguments)
          _original.apply(this, arguments)
          this
  
      else if type is 'after'
        ->
          _original.apply(this, arguments)
          _overrides.apply(this, arguments)
          this
  
      else if type is 'instead'
        ->
          _overrides.apply(this, arguments)
          this
  
      # Migrate class members
      extend(overridden, _original)
  
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
        copy = {}
        if obj.__super__
          extend(copy, obj.__super__)
          copy.constructor = obj.__super__.constructor
          copy.__proto__   = obj.__super__.__proto__
  
        obj.__super__   = copy
        obj.superCopier = obj
      obj.__super__
  
    # http://stackoverflow.com/questions/23570355/how-to-determine-if-variable-was-instantiated-using-new
    wasConstructed = (obj) ->
      obj? and obj.constructor not in [Object, Array, Number, String, Boolean]
  
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
      wasConstructed
      isClass: _.isFunction
    }
  # TODO Refactor this. Make code clean and names shorter
  
  do ->
    {isFunction, isObject, isArray, extend, clone, copySuper} = _
  
    hasOwnProp = {}.hasOwnProperty
  
    baseReopen = (Class, scope, allowFunctions, member, changes) ->
      classScope      = scope is 'ClassMembers'
      instanceScope   = scope is 'InstanceMembers'
      members         = if classScope then Class else Class.prototype
      value           = members[member]
      isDefinedValue  = value?
      isObjectValue   = isDefinedValue and isObject(value) and not isArray(value)
      isArrayValue    = isDefinedValue and not isObjectValue and isArray(value)
      ownerFlag       = "__#{member}Owner"
      changesExist    = arguments.length > 4
  
      if instanceScope and isDefinedValue
        copySuper(Class)[member] = value
  
      if isObjectValue or isArrayValue
  
        # Make own property
  
        # hasOwnProperty does not work on class members as expected
        if classScope
          if member[ownerFlag] isnt Class
            member[ownerFlag] = Class
            value             = clone(value)
            members[member]   = value
  
        else if not hasOwnProp.call(members, member)
          value           = clone(value)
          members[member] = value
  
        if changesExist
  
          # Apply changes inside function
          if allowFunctions and isFunction(changes)
            changes.call(value, value)
  
          # Extend value with new properties
          else if isObject(changes) and not isArray(changes)
            if isObjectValue
              extend(value, changes)
  
            else if isArrayValue
              value.push(changes)
  
          # Push new items into value
          else if isArrayValue
            args    = [value.length, 0]
            i       = 3
            length  = arguments.length
  
            while ++i < length
              arg = arguments[i]
              if isArray(arg)
                args.push.apply(args, arg)
              else
                args.push(arg)
  
            value.splice.apply(value, args)
  
          else
            members[member] = value = changes
  
      else if changesExist
        members[member] = value = changes
  
        if classScope
          Class[ownerFlag] = Class
  
      value
  
    reopeners = {}
  
    createReopener = (scope, allowFunctions) ->
      _scope          = scope
      _allowFunctions = allowFunctions
  
      (Class, member, changes) ->
        len   = arguments.length
        i     = 0
        args  = [Class, _scope, _allowFunctions]
        args.push(arguments[i]) while ++i < len
        baseReopen.apply(null, args)
  
    for scope in ['InstanceMembers', 'ClassMembers']
      for allowFunctions in [true, false]
        name = "reopen#{scope.slice(0, -1)}"
        name += 'With' if allowFunctions
        reopeners[name] = createReopener(scope, allowFunctions)
  
    reopeners.reopen = reopeners.reopenInstanceMember
    reopeners.reopenWith = reopeners.reopenInstanceMemberWith
  
    reopeners.reopenObject = (Class, member) ->
      Class::[member] ||= {}
      reopeners.reopenInstanceMember(arguments...)
  
    reopeners.reopenArray = (Class, member) ->
      Class::[member] ||= []
      reopeners.reopenInstanceMember(arguments...)
  
    define = (prop, func) ->
      unless Function::[prop]
        _func = func
        Object.defineProperty Function::, prop, value: ->
          length  = arguments.length
          i       = -1
          args    = Array(length)
          args[i] = arguments[i] while ++i < length
          args.unshift(this)
          _func.apply(null, args)
  
    for pr in ['reopen', 'reopenWith', 'reopenObject', 'reopenArray']
      define(pr, reopeners[pr])
  
    _.mixin(reopeners)
  
  # No global variable export
  return
)