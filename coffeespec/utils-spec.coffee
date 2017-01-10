describe 'Utils', ->
  
  it 'applyWith', ->
    ret = []
    obj = { set: (args...) -> ret = args.concat(4) }
    _.applyWith(obj.set, obj, [1,2,3])
    expect(ret).toEqual([1,2,3,4])
    
  it 'firstOf', ->
    expect(_.firstOf({x: 'x', y: 'y'})).toEqual('x')
    expect(_.firstOf([1,2,3,4,5])).toEqual(1)
    expect(_.firstOf([])).toBeUndefined()
    
  it 'generateID', ->
    expect(_.generateID()).toBe(1)
    expect(_.generateID()).toBe(2)
    expect(_.generateID()).toBe(3)
    
  it 'isConstructed', ->
    class Class
    expect(_.isConstructed({})).toBe(false)
    expect(_.isConstructed(new Array())).toBe(false)
    expect(_.isConstructed(new Class())).toBe(true)
  
  it 'isEnabled', ->
    expect(_.isEnabled({x: false}, 'x')).toBe(false)
    expect(_.isEnabled({x: null}, 'x')).toBe(true)
    expect(_.isEnabled({}, 'x')).toBe(true)
