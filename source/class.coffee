{extend} = _

overrideConstructor = (original, overrides, options) ->
  prototype = original.prototype

  overridden = if options.before
    ->
      overrides.apply(this, arguments)
      original.apply(this, arguments)
      this

  else if options.after
    ->
      original.apply(this, arguments)
      overrides.apply(this, arguments)
      this

  else if options.instead
    ->
      overrides.apply(this, arguments)
      this

  # Migrate class members
  extend(overridden, original);

  # Migrate prototype
  overridden.prototype = prototype
  overridden.prototype.constructor = overridden
  overridden

_.mixin {overrideConstructor}