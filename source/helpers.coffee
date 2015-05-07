{extend, uniqueId, mixin} = _

isEnabled = (options, option) ->
  !options or options[option] is undefined or !!options[option]

generateId = -> +uniqueId()

mixin {isEnabled, generateId}