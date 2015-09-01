do ->
  {isFunction, isObject, isArray, extend, clone, copySuper} = _

  hasOwnProp = {}.hasOwnProperty

  baseReopen = (Class, scope, allowFunctions, member, changes) ->
    classScope    = scope is 'ClassMembers'
    instanceScope = scope is 'InstanceMembers'

    unless classScope or instanceScope
      throw new Error('[CoffeeConcerns] Invalid scope')

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