do ->
  {isFunction, isObject, isArray, extend, clone, privatizeSuperclass} = _

  hasOwnProperty = {}.hasOwnProperty

  baseReopen = (Class, scope, allowFunctions, member, changes) ->
    isClassScope       = scope is 'ClassMembers'
    isInstanceScope    = scope is 'InstanceMembers'
    members            = if isClassScope then Class else Class.prototype
    value              = members[member]
    isDefinedValue     = value?
    isObjectValue      = isDefinedValue and isObject(value) and not isArray(value)
    isArrayValue       = isDefinedValue and not isObjectValue and isArray(value)
    hasOwnPropertyFlag = "__#{member}PropertyOwner"
    changesExist       = arguments.length > 4

    if Class.__super__? and isInstanceScope and isDefinedValue
      privatizeSuperclass(Class)
      Class.__super__[member] = value

    if isObjectValue or isArrayValue

      # Make own property

      # hasOwnProperty does not work on class members as expected
      if isClassScope
        if member[hasOwnPropertyFlag] isnt Class
          member[hasOwnPropertyFlag] = Class
          value             = clone(value)
          members[member]   = value

      else if not hasOwnProperty.call(members, member)
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
          args = [value.length, 0]
          idx  = 3
          len  = arguments.length
          args.push(arguments[idx]) while ++idx < len
          value.splice.apply(value, args)
        else
          members[member] = value = changes

    else if changesExist
      members[member] = value = changes

      if isClassScope
        Class[hasOwnPropertyFlag] = Class

    value

  reopenInstanceMember     = (Class, member, changes...) -> baseReopen([Class, 'InstanceMembers', false, member].concat(changes)...)
  reopenInstanceMemberWith = (Class, member, changes...) -> baseReopen([Class, 'InstanceMembers', true, member].concat(changes)...)
  reopenClassMember        = (Class, member, changes...) -> baseReopen([Class, 'ClassMembers', false, member].concat(changes)...)
  reopenClassMemberWith    = (Class, member, changes...) -> baseReopen([Class, 'ClassMembers', true, member].concat(changes)...)
  reopenObject             = (Class, member) -> Class::[member] ?= {}; reopenInstanceMember(arguments...)
  reopenArray              = (Class, member) -> Class::[member] ?= []; reopenInstanceMember(arguments...)
  reopen                   = reopenInstanceMember
  reopenWith               = reopenInstanceMemberWith

  Object.defineProperty Function::, 'reopen',       value: -> reopen(this, arguments...)
  Object.defineProperty Function::, 'reopenWith',   value: -> reopenWith(this, arguments...)
  Object.defineProperty Function::, 'reopenObject', value: -> reopenObject(this, arguments...)
  Object.defineProperty Function::, 'reopenArray',  value: -> reopenArray(this, arguments...)
    
  _.mixin {reopen, reopenWith, reopenArray, reopenObject, reopenClassMember, reopenClassMemberWith}
