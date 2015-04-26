{extend, uniqueId} = _

isEnabled = (options, option) ->
  not options or options[option] is undefined or !!options[option]

generateId = -> +uniqueId()

extend yess, {isEnabled, generateId}