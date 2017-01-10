replaceAll = (ary, items) ->
  if items?.length > 0
    ary.splice.apply(ary, [0, ary.length].concat(items))
  else
    ary.splice(0, ary.length)

_.mixin {replaceAll}, chain: false
