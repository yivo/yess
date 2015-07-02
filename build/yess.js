(function() {
  var slice = [].slice;

  (function(root, factory) {
    if (typeof define === 'function' && define.amd) {
      define(['lodash'], function(_) {
        return factory(root, _);
      });
    } else if (typeof module === 'object' && typeof module.exports === 'object') {
      factory(root, require('lodash'));
    } else {
      factory(root, root._);
    }
  })(this, function(root, _) {
    var afterConstructor, afterFunction, afterMethod, applyWith, beforeConstructor, beforeFunction, beforeMethod, bindMethod, copySuper, createObject, debounceMethod, eachToken, equalArrays, extend, generateId, getProperty, insertAt, insertManyAt, insertOneAt, insteadConstructor, isArray, isEnabled, isFunction, lodashBind, lodashDebounce, lodashOnce, mapMethod, nativeSlice, nativeSort, nativeSplice, onceMethod, overrideConstructor, overrideFunction, overrideMethod, removeAt, replaceAll, setProperty, traverseObject, uniqueId, wasConstructed;
    isArray = _.isArray;
    nativeSplice = Array.prototype.splice;
    nativeSlice = Array.prototype.slice;
    nativeSort = Array.prototype.sort;
    insertManyAt = function(array, items, pos) {
      if (items.length) {
        return nativeSplice.apply(array, [pos, 0].concat(items));
      }
    };
    insertOneAt = function(array, item, pos) {
      return nativeSplice.call(array, pos, 0, item);
    };
    insertAt = function(array, items, pos) {
      if (isArray(items)) {
        return insertManyAt(array, items, pos);
      } else {
        return insertOneAt(array, items, pos);
      }
    };
    replaceAll = function(array, items) {
      if (items && items.length) {
        return nativeSplice.apply(array, [0, array.length].concat(items));
      } else {
        return nativeSplice.call(array, 0, array.length);
      }
    };
    removeAt = function(array, pos, num) {
      if (num == null) {
        num = 1;
      }
      if (pos > -1 && num > 0 && (pos + num) <= array.length) {
        return nativeSplice.call(array, pos, num);
      }
    };
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
      insertAt: insertAt,
      insertOneAt: insertOneAt,
      insertManyAt: insertManyAt,
      replaceAll: replaceAll,
      removeAt: removeAt,
      equalArrays: equalArrays,
      nativeSlice: nativeSlice,
      nativeSplice: nativeSplice,
      nativeSort: nativeSort
    });
    isFunction = _.isFunction, extend = _.extend;
    lodashBind = _.bind;
    lodashDebounce = _.debounce;
    lodashOnce = _.once;
    applyWith = function(func, context, args) {
      var arg1, arg2, arg3;
      arg1 = args[0];
      arg2 = args[1];
      arg3 = args[2];
      switch (args.length) {
        case 0:
          return func.call(context);
        case 1:
          return func.call(context, arg1);
        case 2:
          return func.call(context, arg1, arg2);
        case 3:
          return func.call(context, arg1, arg2, arg3);
        default:
          return func.apply(context, args);
      }
    };
    mapMethod = function(object, method) {
      if (isFunction(method)) {
        return method;
      } else {
        return object && object[method];
      }
    };
    debounceMethod = function(object, method, time, options) {
      return object[method] = lodashDebounce(object[method], time, options);
    };
    bindMethod = function() {
      var k, len1, method, methods, object;
      object = arguments[0], methods = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      for (k = 0, len1 = methods.length; k < len1; k++) {
        method = methods[k];
        object[method] = lodashBind(object[method], object);
      }
    };
    onceMethod = function() {
      var k, len1, method, methods, object;
      object = arguments[0], methods = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      for (k = 0, len1 = methods.length; k < len1; k++) {
        method = methods[k];
        object[method] = lodashOnce(object[method]);
      }
    };
    wasConstructed = function(obj) {
      var ref;
      return (ref = obj.constructor) !== Object && ref !== Array && ref !== Number && ref !== String && ref !== Boolean;
    };
    _.mixin({
      applyWith: applyWith,
      onceMethod: onceMethod,
      bindMethod: bindMethod,
      debounceMethod: debounceMethod,
      mapMethod: mapMethod,
      wasConstructed: wasConstructed
    });
    createObject = function() {
      var i, len, obj;
      obj = {};
      i = -1;
      len = arguments.length;
      while ((i += 2) < len) {
        obj[arguments[i - 1]] = arguments[i];
      }
      return obj;
    };
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
      createObject: createObject,
      traverseObject: traverseObject,
      setProperty: setProperty,
      getProperty: getProperty
    });
    extend = _.extend, uniqueId = _.uniqueId;
    isEnabled = function(options, option) {
      return !options || options[option] === void 0 || !!options[option];
    };
    generateId = function() {
      return +uniqueId();
    };
    _.mixin({
      isEnabled: isEnabled,
      generateId: generateId
    });
    eachToken = function(str, callback) {
      var i, j, len;
      len = str.length;
      i = -1;
      j = 0;
      while (++i <= len) {
        if (i === len || str[i] === ' ') {
          if (j > 0) {
            callback(str.slice(i - j, i), str);
          }
          j = 0;
        } else {
          ++j;
        }
      }
    };
    _.mixin({
      eachToken: eachToken
    });
    extend = _.extend;
    overrideFunction = function(original, overrides, type) {
      if (type == null) {
        type = 'before';
      }
      return function() {
        var ret;
        switch (type) {
          case 'before':
            overrides.apply(this, arguments);
            ret = original.apply(this, arguments);
            break;
          case 'after':
            ret = original.apply(this, arguments);
            overrides.apply(this, arguments);
        }
        return ret;
      };
    };
    overrideMethod = function(object, method, overrides, type) {
      return object[method] = overrideFunction(object[method], overrides, type);
    };
    overrideConstructor = function(original, overrides, type) {
      var overridden, prototype;
      if (type == null) {
        type = 'before';
      }
      prototype = original.prototype;
      overridden = type === 'before' ? function() {
        overrides.apply(this, arguments);
        original.apply(this, arguments);
        return this;
      } : type === 'after' ? function() {
        original.apply(this, arguments);
        overrides.apply(this, arguments);
        return this;
      } : type === 'instead' ? function() {
        overrides.apply(this, arguments);
        return this;
      } : void 0;
      extend(overridden, original);
      overridden.prototype = prototype;
      overridden.prototype.constructor = overridden;
      return overridden;
    };
    beforeConstructor = function(original, overrides) {
      return overrideConstructor(original, overrides, 'before');
    };
    afterConstructor = function(original, overrides) {
      return overrideConstructor(original, overrides, 'after');
    };
    insteadConstructor = function(original, overrides) {
      return overrideConstructor(original, overrides, 'instead');
    };
    beforeFunction = function(original, overrides) {
      return overrideFunction(original, overrides, 'before');
    };
    afterFunction = function(original, overrides) {
      return overrideFunction(original, overrides, 'after');
    };
    beforeMethod = function(object, method, overrides) {
      return overrideMethod(object, method, overrides, 'before');
    };
    afterMethod = function(object, method, overrides) {
      return overrideMethod(object, method, overrides, 'after');
    };
    copySuper = function(obj) {
      var copy;
      if (obj.superCopier !== obj) {
        if (obj.__super__) {
          copy = extend({}, obj.__super__);
          copy.constructor = obj.__super__.constructor;
          obj.__super__ = copy;
        } else {
          obj.__super__ = {};
        }
        obj.superCopier = obj;
      }
      return obj.__super__;
    };
    _.mixin({
      overrideConstructor: overrideConstructor,
      overrideFunction: overrideFunction,
      overrideMethod: overrideMethod,
      beforeConstructor: beforeConstructor,
      afterConstructor: afterConstructor,
      insteadConstructor: insteadConstructor,
      beforeFunction: beforeFunction,
      afterFunction: afterFunction,
      beforeMethod: beforeMethod,
      afterMethod: afterMethod,
      copySuper: copySuper,
      isClass: _.isFunction
    });
  });

}).call(this);
