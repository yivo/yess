do ->
  eachToken = (str, callback) ->
    len = str.length
    i   = -1
    j   = 0
    while ++i <= len
      if i is len or str[i] is ' '
        if j > 0
          callback(str[i - j...i], str)
        j = 0
      else ++j
    return

  _.mixin {eachToken}