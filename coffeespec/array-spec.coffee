describe 'Array', ->
  
  it 'equalArrays', ->
    expect(_.equalArrays([1,2,3], [1,2,3])).toBe(true)
    expect(_.equalArrays([1,2,'3'], [1,2,3])).toBe(false)

  it 'inGroupsOf', ->
    expect(_.inGroupsOf(2, [1,2,3,4])).toEqual([[1,2], [3,4]])
    groups = []
    expect(_.inGroupsOf(2, [1,2,3,4], (group) -> groups.push(group))).toEqual(groups)

  it 'insertAt', ->
    expect(_.insertAt([1,2], 3, 2)).toEqual([1,2,3])
    expect(_.insertAt([1,2], [3,4], 2)).toEqual([1,2,3,4])

  it 'removeAt', ->
    ary = [1,2,3,4,5]
    expect(_.removeAt(ary, 1)).toEqual([2])
    expect(ary).toEqual([1,3,4,5])

    ary = [1,2,3,4,5]
    expect(_.removeAt(ary, 0, 4)).toEqual([1,2,3,4])
    expect(ary).toEqual([5])
    
  it 'replaceAll', ->
    ary = [1,2,3,4,5]
    expect(_.replaceAll(ary, [9,9,9])).toEqual([1,2,3,4,5])
    expect(ary).toEqual([9,9,9])
