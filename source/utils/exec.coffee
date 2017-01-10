# http://jsperf.com/apply-vs-custom-apply
exec = (func, context, args) ->
  switch args.length
    when 0 then func.call(context)
    when 1 then func.call(context, args[0])
    when 2 then func.call(context, args[0], args[1])
    when 3 then func.call(context, args[0], args[1], args[2])
    else func.apply(context, args)

_.mixin {exec}, chain: false
