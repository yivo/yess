isEnabled = (options, optionname) ->
  options isnt false and options?[optionname] isnt false

_.mixin {isEnabled}, chain: false
