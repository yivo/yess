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
      if obj.__super__
        if Object.create
          copy = Object.create(obj.__super__)
        else
          copy = extend({}, obj.__super__)
          ctor = -> @constructor = copy
          ctor.prototype = obj.__super__.prototype
          copy.prototype = new ctor()

        copy.constructor = obj.__super__.constructor
      else
        copy = {}

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
