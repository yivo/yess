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