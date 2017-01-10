inGroupsOf = (n, array, iteratee) ->
  groups = []
  l = array.length
  i = -1
  while ++i < l
    j = 0
    group = []
    while (++j <= n) and (i + j - 1) < l
      group.push(array[i + j - 1])
    iteratee?(group, array)
    groups.push(group) if group.length > 0
    i = i + j - 2
  groups
  
_.mixin {inGroupsOf}, chain: false
