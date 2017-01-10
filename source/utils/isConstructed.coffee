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
