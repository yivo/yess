# _.createObject('foo', 'bar', 'baz', 'qux') => { foo: 'bar', baz: 'qux' }
createObject = ->
  obj = {}
  idx = -1
  len = arguments.length
  while (idx += 2) < len
    obj[arguments[idx - 1]] = arguments[idx]
  obj

_.mixin {createObject}, chain: false
