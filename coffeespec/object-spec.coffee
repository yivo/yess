describe 'Object', ->
  
  it 'createObject', ->
    expect(_.createObject('x', 1, 'y', 2)).toEqual(x: 1, y: 2)
    
  it 'firstKey', ->
    expect(_.firstKey({x: 1, y: 2})).toEqual('x')
    
  it 'firstValue', ->
    expect(_.firstValue({x: 1, y: 2})).toEqual(1)
    
  it 'getProperty', ->
    expect(_.getProperty({x:{y:{z:1}}}, 'x.y.z')).toEqual(1)
    expect(_.getProperty({}, 'x.y.z')).toBeUndefined()
  
  it 'setProperty', ->
    obj = {x:{y:{z:1}}}
    expect(_.setProperty(obj, 'x.y.z', 2)).toBe(obj)
    expect(obj.x.y.z).toEqual(2)

    obj = {}
    expect(_.setProperty(obj, 'x.y.z', 1)).toBe(obj)
    expect(obj).toEqual({x:{y:{z:1}}})

  it 'keyval', ->
    expect(_.keyval(x: 'y')).toEqual(['x', 'y'])
