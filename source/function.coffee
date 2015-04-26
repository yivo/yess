{isFunction, extend} = _

lodashBind     = _.bind
lodashDebounce = _.debounce

# @see http://jsperf.com/apply-vs-custom-apply
apply = (func, obj, args) ->
  arg1 = args[0]
  arg2 = args[1]
  arg3 = args[2]
  switch args.length
    when 0 then func.call(obj)
    when 1 then func.call(obj, arg1)
    when 2 then func.call(obj, arg1, arg2)
    when 3 then func.call(obj, arg1, arg2, arg3)
    else func.apply(obj, args)

mapMethod = (object, method) ->
  if isFunction(method) then method else object and object[method]

debounce = (object, method, time, options) ->
  object[method] = lodashDebounce(lodashBind(object[method], object), time, options)

bind = (object, methods...) ->
  for method in methods
    object[method] = lodashBind(object[method], object)
  return

once = (object, methods...) ->
  for method in methods
    real = object[method]

    wrapper = do (object, real) ->
      run = no
      memo = undefined
      ->
        unless run
          run = yes
          memo = real.apply(object, arguments)

          # Break references!
          object = null
          real = null
        memo

    object[method] = wrapper
  return

extend yess, {apply, once, bind, debounce, mapMethod}