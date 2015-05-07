{extend, uniqueId} = _

isEnabled = (options, option) ->
  !options or options[option] is undefined or !!options[option]

generateId = -> +uniqueId()

_.mixin {isEnabled, generateId}