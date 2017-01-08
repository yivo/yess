describe 'Property when reopened', ->

  it 'should correctly be extended', ->
    class Base
      hash: {foo: 1, bar: 2}
      array: [1,2,3]

    class Foo extends Base
      @reopen 'hash', baz: 3
      @reopen 'array', [4]

    class Bar extends Base
      @reopen 'hash', bar: 42
      @reopenWith 'array', (array) -> array.shift()

    expect(Base::hash).toEqual foo: 1, bar:2
    expect(Base::array).toEqual [1,2,3]

    expect(Foo::hash).toEqual foo: 1, bar: 2, baz: 3
    expect(Foo::array).toEqual [1,2,3,[4]]

    expect(Bar::hash).toEqual _.extend({}, Base::hash, bar: 42)
    expect(Bar::array).toEqual Base::array.slice(1)

    expect(Foo.__super__.hash).toBe Base::hash
    expect(Foo.__super__.array).toBe Base::array

    expect(Bar.__super__.hash).toBe Base::hash
    expect(Bar.__super__.array).toBe Base::array

    previous = Bar::hash

    Bar.reopen('hash', bar: 50)

    expect(Bar::hash).toBe previous
    expect(Bar::hash).toEqual _.extend({}, Base::hash, bar: 50)

  it 'should set property when it is not defined', ->
    class Foo
      @reopen 'property', [1,2,3]

    class Bar
      @reopen 'property', banana: 1
      @reopen 'string', 'Hello!'

    expect(Foo::property).toEqual [1,2,3]
    expect(Bar::property).toEqual banana: 1
    expect(Bar::string).toEqual 'Hello!'

  it 'should correctly save previous value in super', ->
    class Base
      hash: foo: 1

    class Derived1 extends Base
      @reopen 'hash', bar: 2

    class Derived11 extends Derived1
      @reopen 'hash', baz: 3

    class Derived2 extends Base
      @reopen 'hash', qux: 4
      @reopen 'array', []

    class Derived22 extends Derived2
      @reopen 'array', [1]

    expect(Derived1.__super__).not.toBe Base::
    expect(Derived11.__super__).not.toBe Derived1::
    expect(Derived2.__super__).not.toBe Base::
    expect(Derived22.__super__).not.toBe Derived2::

    expect(Derived1.__super__.hash).toBe Base::hash
    expect(Derived2.__super__.hash).toBe Base::hash

    expect(Derived11.__super__.hash).toBe Derived1::hash

    expect(Derived2::array).toEqual []
    expect(Derived22::array).toEqual [1]

  describe 'through reopenArray', ->
    it 'should set empty array when it is not defined', ->
      class Foo
        @reopenArray 'array', 1, 2, 3
      expect(Foo::array).toEqual [1, 2, 3]

  describe 'through reopenObject', ->
    it 'should set empty object when it is not defined', ->
      class Foo
        @reopenObject 'object', val: 1
      expect(Foo::object).toEqual val: 1

  describe 'in class members', ->
    it 'should correctly be extended', ->
      class Foo
        @hash: {foo: 1, bar: 2}

      _.reopenClassMember Foo, 'hash', baz: 3

      class Bar extends Foo

      _.reopenClassMember Bar, 'hash', baz: 4

      expect(Foo.hash).toEqual foo: 1, bar: 2, baz: 3

      expect(Bar.hash).toEqual foo: 1, bar: 2, baz: 4

      _.reopenClassMember Foo, 'hash', 17
      expect(Foo.hash).toEqual 17
      expect(Bar.hash).toEqual foo: 1, bar: 2, baz: 4
