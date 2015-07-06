{extend, uniqueId} = _

isEnabled = (options, option) ->
  options isnt false and options?[option] isnt false

generateId = -> +uniqueId()

_.mixin {isEnabled, generateId}