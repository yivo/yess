describe 'Class', ->
  
  it 'bindMethod', ->
    obj = { foo: -> 'bar' }
    _.bindMethod(obj, 'foo')
    expect(obj.foo.call(null)).toEqual('bar')
    
  it 'debounceMethod', (done) ->
    ary = []
    obj = { push: -> ary.push(1) }
    _.debounceMethod(obj, 'push', 30)
    obj.push()
    obj.push()
    obj.push()
    setTimeout ->
      expect(ary).toEqual([1])
      done()
    , 30
    
  it 'isClass', ->
    class Class
    expect(_.isClass(Class)).toBe(true)

  it 'mapMethod', ->
    obj = { foo: -> }
    expect(_.mapMethod(obj, 'foo')).toBe(obj.foo)
    expect(_.mapMethod(obj, obj.foo)).toBe(obj.foo)

  it 'onceMethod', ->
    ary = []
    obj = { push: -> ary.push(1) }
    _.onceMethod(obj, 'push')
    obj.push()
    obj.push()
    obj.push()
    expect(ary).toEqual([1])
    
  it 'privatizeSuperclass', ->
    class Base
    class Foo extends Base
    class Bar extends Base
    Foo__super__ = Foo.__super__
    Bar__super__ = Bar.__super__
    
    _.privatizeSuperclass(Foo)
    _.privatizeSuperclass(Bar)
    
    expect(Foo.__super__).not.toBe(Foo__super__)
    expect(Bar.__super__).not.toBe(Bar__super__)
