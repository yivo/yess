{isFunction, extend} = _

lodashBind     = _.bind
lodashDebounce = _.debounce
lodashOnce     = _.once

# @see http://jsperf.com/apply-vs-custom-apply
applyWith = (func, context, args) ->
  arg1 = args[0]
  arg2 = args[1]
  arg3 = args[2]
  switch args.length
    when 0 then func.call(context)
    when 1 then func.call(context, arg1)
    when 2 then func.call(context, arg1, arg2)
    when 3 then func.call(context, arg1, arg2, arg3)
    else func.apply(context, args)

mapMethod = (object, method) ->
  if isFunction(method)
    method
  else
    object and object[method]

debounceMethod = (object, method, time, options) ->
  object[method] = lodashDebounce(object[method], time, options)

bindMethod = (object, methods...) ->
  for method in methods
    object[method] = lodashBind(object[method], object)
  return

onceMethod = (object, methods...) ->
  for method in methods
    object[method] = lodashOnce(object[method])
  return

# http://stackoverflow.com/questions/23570355/how-to-determine-if-variable-was-instantiated-using-new
wasConstructed = (obj) ->
  obj.constructor not in [Object, Array, Number, String, Boolean]

_.mixin {applyWith, onceMethod, bindMethod, debounceMethod, mapMethod, wasConstructed}