do ->
  {extend} = _

  privatizeSuperclass = (Class) ->
    if Class.__super__? and not Class.__superclassPrivatized__
      
      if Object.create?
        copy = Object.create(Class.__super__)
      else
        copy = extend({}, Class.__super__)
        ctor = -> @constructor = copy
        ctor.prototype = Class.__super__.prototype
        copy.prototype = new ctor()

      copy.constructor = Class.__super__.constructor

      Class.__superclassPrivatized__ = true
      Class.__super__                = copy
    return
    
  _.mixin {
    privatizeSuperclass,
    
    # COMPATIBILITY: This is old name
    copySuper: privatizeSuperclass
  }
