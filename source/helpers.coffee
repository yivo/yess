do ->
  isEnabled = (options, key) ->
    options isnt false and options?[key] isnt false

  generateID = do ->
    n = 0
    -> ++n

  _.mixin {isEnabled, generateID}
