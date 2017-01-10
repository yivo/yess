(function() {
  var slice = [].slice,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  (function(factory) {
    var root;
    root = typeof self === 'object' && self !== null && self.self === self ? self : typeof global === 'object' && global !== null && global.global === global ? global : void 0;
    if (typeof define === 'function' && typeof define.amd === 'object' && define.amd !== null) {
      define(['lodash', 'exports'], function(_) {
        return root._ = factory(root, Object, Array, Number, String, Boolean, _);
      });
    } else if (typeof module === 'object' && module !== null && typeof module.exports === 'object' && module.exports !== null) {
      module.exports = factory(root, Object, Array, Number, String, Boolean, require('lodash'));
    } else {
      root._ = factory(root, Object, Array, Number, String, Boolean, root._);
    }
  })(function(__root__, Object, Array, Number, String, Boolean, _) {
    var NATIVES, applyWith, createObject, equalArrays, generateID, getProperty, inGroupsOf, insertManyAt, insertOneAt, isConstructed, isEnabled, removeAt, replaceAll, setProperty, traverseObject;
    equalArrays = function(array, other) {
      var i, item, k, len1;
      if (array === other) {
        return true;
      }
      if (array.length !== other.length) {
        return false;
      }
      for (i = k = 0, len1 = array.length; k < len1; i = ++k) {
        item = array[i];
        if (item !== other[i]) {
          return false;
        }
      }
      return true;
    };
    _.mixin({
      equalArrays: equalArrays
    });
    inGroupsOf = function(n, array, iteratee) {
      var group, groups, i, j, l;
      groups = [];
      l = array.length;
      i = -1;
      while (++i < l) {
        j = 0;
        group = [];
        while ((++j <= n) && (i + j - 1) < l) {
          group.push(array[i + j - 1]);
        }
        if (typeof iteratee === "function") {
          iteratee(group, array);
        }
        if (group.length > 0) {
          groups.push(group);
        }
        i = i + j - 2;
      }
      return groups;
    };
    _.mixin({
      inGroupsOf: inGroupsOf
    });
    insertOneAt = function(ary, item, pos) {
      if ((pos | 0) <= ary.length) {
        ary.splice(pos | 0, 0, item);
      }
      return ary;
    };
    _.mixin({
      insertOneAt: insertOneAt
    });
    insertManyAt = function(ary, items, pos) {
      if ((pos | 0) <= ary.length) {
        ary.splice.apply(ary, [pos | 0, 0].concat(items));
      }
      return ary;
    };
    _.mixin({
      insertManyAt: insertManyAt
    });
    (function() {
      var insertAt, isArray;
      isArray = _.isArray, insertOneAt = _.insertOneAt, insertManyAt = _.insertManyAt;
      insertAt = function(ary, items, pos) {
        if (isArray(items)) {
          insertManyAt(ary, items, pos | 0);
        } else {
          insertOneAt(ary, items, pos | 0);
        }
        return ary;
      };
      return _.mixin({
        insertAt: insertAt
      });
    })();
    removeAt = function(ary, pos, num) {
      var _num;
      _num = num | 0;
      if (_num === 0) {
        _num = 1;
      }
      if (pos > -1 && _num > 0 && (pos + _num) <= ary.length) {
        return ary.splice(pos, _num);
      }
    };
    _.mixin({
      removeAt: removeAt
    });
    replaceAll = function(ary, items) {
      if ((items != null ? items.length : void 0) > 0) {
        return ary.splice.apply(ary, [0, ary.length].concat(items));
      } else {
        return ary.splice(0, ary.length);
      }
    };
    _.mixin({
      replaceAll: replaceAll
    });
    (function() {
      var bind, bindMethod;
      bind = _.bind;
      bindMethod = function() {
        var k, len1, method, methods, object;
        object = arguments[0], methods = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        for (k = 0, len1 = methods.length; k < len1; k++) {
          method = methods[k];
          object[method] = bind(object[method], object);
        }
      };
      return _.mixin({
        bindMethod: bindMethod
      });
    })();
    (function() {
      var debounce, debounceMethod;
      debounce = _.debounce;
      debounceMethod = function(object, method, time, options) {
        return object[method] = debounce(object[method], time, options);
      };
      return _.mixin({
        debounceMethod: debounceMethod
      });
    })();
    _.mixin({
      isClass: _.isFunction
    });
    (function() {
      var isFunction, mapMethod;
      isFunction = _.isFunction;
      mapMethod = function(object, method) {
        if (isFunction(method)) {
          return method;
        } else {
          return object != null ? object[method] : void 0;
        }
      };
      return _.mixin({
        mapMethod: mapMethod
      });
    })();
    (function() {
      var once, onceMethod;
      once = _.once;
      onceMethod = function() {
        var k, len1, method, methods, object;
        object = arguments[0], methods = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        for (k = 0, len1 = methods.length; k < len1; k++) {
          method = methods[k];
          object[method] = once(object[method]);
        }
      };
      return _.mixin({
        onceMethod: onceMethod
      });
    })();
    (function() {
      var extend, privatizeSuperclass;
      extend = _.extend;
      privatizeSuperclass = function(Class) {
        var copy, ctor;
        if ((Class.__super__ != null) && !Class.__superclassPrivatized__) {
          if (Object.create != null) {
            copy = Object.create(Class.__super__);
          } else {
            copy = extend({}, Class.__super__);
            ctor = function() {
              return this.constructor = copy;
            };
            ctor.prototype = Class.__super__.prototype;
            copy.prototype = new ctor();
          }
          copy.constructor = Class.__super__.constructor;
          Class.__superclassPrivatized__ = true;
          Class.__super__ = copy;
        }
      };
      return _.mixin({
        privatizeSuperclass: privatizeSuperclass,
        copySuper: privatizeSuperclass
      });
    })();
    createObject = function() {
      var idx, len, obj;
      obj = {};
      idx = -1;
      len = arguments.length;
      while ((idx += 2) < len) {
        obj[arguments[idx - 1]] = arguments[idx];
      }
      return obj;
    };
    _.mixin({
      createObject: createObject
    });
    (function() {
      var firstKey, keys;
      keys = _.keys;
      firstKey = function(obj) {
        var _keys;
        _keys = keys(obj);
        if (_keys.length > 0) {
          return _keys[0];
        }
      };
      return _.mixin({
        firstKey: firstKey
      });
    })();
    (function() {
      var firstValue, keys;
      keys = _.keys;
      firstValue = function(obj) {
        var _keys;
        _keys = keys(obj);
        if (_keys.length > 0) {
          return obj[_keys[0]];
        }
      };
      return _.mixin({
        firstValue: firstValue
      });
    })();
    traverseObject = getProperty = function(obj, path) {
      var _obj, i, j, len, prop;
      _obj = obj;
      len = path.length;
      i = -1;
      j = 0;
      while (++i <= len && (_obj != null)) {
        if (i === len || path[i] === '.') {
          if (j > 0) {
            prop = path.slice(i - j, i);
            _obj = _obj[prop];
            if (_obj == null) {
              return _obj;
            }
            j = 0;
          }
        } else {
          ++j;
        }
      }
      if (i > 0) {
        return _obj;
      }
    };
    _.mixin({
      traverseObject: traverseObject,
      getProperty: getProperty
    });
    setProperty = function(obj, path, val) {
      var before, i, j, len, now, prop;
      now = obj;
      len = path.length;
      i = -1;
      j = 0;
      while (++i <= len) {
        if (i === len || path[i] === '.') {
          if (j > 0) {
            before = now;
            if (prop && ((now = before[prop]) == null)) {
              now = before[prop] = {};
            }
            prop = path.slice(i - j, i);
            j = 0;
          }
        } else {
          ++j;
        }
      }
      if (prop) {
        now[prop] = val;
      }
      return obj;
    };
    _.mixin({
      setProperty: setProperty
    });
    applyWith = function(func, context, args) {
      switch (args.length) {
        case 0:
          return func.call(context);
        case 1:
          return func.call(context, args[0]);
        case 2:
          return func.call(context, args[0], args[1]);
        case 3:
          return func.call(context, args[0], args[1], args[2]);
        default:
          return func.apply(context, args);
      }
    };
    _.mixin({
      applyWith: applyWith
    });
    (function() {
      var firstOf, isArray, isObject, keys, ref, ref1;
      keys = _.keys;
      isArray = (ref = _.isArrayLike) != null ? ref : _.isArray;
      isObject = (ref1 = _.isObjectLike) != null ? ref1 : _.isObject;
      firstOf = function(arg) {
        var _keys;
        if (isArray(arg)) {
          if (arg.length > 0) {
            return arg[0];
          }
        } else if (isObject(arg)) {
          _keys = keys(arg);
          if (_keys.length > 0) {
            return arg[_keys[0]];
          }
        } else {
          return arg;
        }
      };
      return _.mixin({
        firstOf: firstOf
      });
    })();
    generateID = (function() {
      var n;
      n = 0;
      return function() {
        return ++n;
      };
    })();
    _.mixin({
      generateID: generateID
    });
    NATIVES = [Object, Array, Number, String, Boolean];
    if (typeof Object.freeze === "function") {
      Object.freeze(NATIVES);
    }
    isConstructed = function(object) {
      var ref;
      return (object != null) && (ref = object.constructor, indexOf.call(NATIVES, ref) < 0);
    };
    _.mixin({
      isConstructed: isConstructed,
      wasConstructed: isConstructed
    });
    isEnabled = function(options, optionname) {
      return options !== false && (options != null ? options[optionname] : void 0) !== false;
    };
    _.mixin({
      isEnabled: isEnabled
    });
    return _;
  });

}).call(this);
