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