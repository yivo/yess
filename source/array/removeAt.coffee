removeAt = (ary, pos, num) ->
  _num = num|0
  _num = 1 if _num is 0
  ary.splice(pos, _num) if pos > -1 and _num > 0 and (pos + _num) <= ary.length

_.mixin {removeAt}, chain: false
