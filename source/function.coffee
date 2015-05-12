{isFunction, extend} = _

lodashBind     = _.bind
lodashDebounce = _.debounce

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
  object[method] = lodashDebounce(lodashBind(object[method], object), time, options)

bindMethod = (object, methods...) ->
  for method in methods
    object[method] = lodashBind(object[method], object)
  return

onceMethod = (object, methods...) ->
  for name in methods
    method = object[name]

    wrapper = do (object, method) ->
      run  = no
      memo = undefined
      ->
        unless run
          run  = yes
          memo = method.apply(object, arguments)

          # Break references!
          object = method = null
        memo

    object[name] = wrapper
  return

_.mixin {applyWith, onceMethod, bindMethod, debounceMethod, mapMethod}