(function() {
  var slice = [].slice;

  (function(factory) {
    var root;
    root = typeof self === 'object' && (typeof self !== "undefined" && self !== null ? self.self : void 0) === self ? self : typeof global === 'object' && (typeof global !== "undefined" && global !== null ? global.global : void 0) === global ? global : void 0;
    if (typeof define === 'function' && define.amd) {
      define(['lodash', 'exports'], function(_) {
        return factory(root, _);
      });
    } else if (typeof module === 'object' && module !== null && (module.exports != null) && typeof module.exports === 'object') {
      factory(root, require('lodash'));
    } else {
      factory(root, root._);
    }
  })(function(__root__, _) {
    (function() {
      var equalArrays, firstKey, firstOf, firstValue, inGroupsOf, insertAt, insertManyAt, insertOneAt, isArray, isObject, keys, removeAt, replaceAll;
      isArray = _.isArray, isObject = _.isObject, keys = _.keys;
      insertManyAt = function(ary, items, pos) {
        if ((pos | 0) <= items.length) {
          return ary.splice.apply(ary, [pos | 0, 0].concat(items));
        }
      };
      insertOneAt = function(ary, item, pos) {
        if ((pos | 0) <= items.length) {
          return ary.splice(pos | 0, 0, item);
        }
      };
      insertAt = function(ary, items, pos) {
        if (isArray(items)) {
          return insertManyAt(ary, items, pos | 0);
        } else {
          return insertOneAt(ary, items, pos | 0);
        }
      };
      replaceAll = function(ary, items) {
        if ((items != null ? items.length : void 0) > 0) {
          return ary.splice.apply(ary, [0, ary.length].concat(items));
        } else {
          return ary.splice(0, ary.length);
        }
      };
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
      inGroupsOf = function(n, array, iteratee) {
        var group, groups, i, j, l;
        if (!iteratee) {
          groups = [];
        }
        l = array.length;
        i = -1;
        while (++i < l) {
          j = 0;
          group = [];
          while ((++j <= n) && (i + j - 1) < l) {
            group.push(array[i + j - 1]);
          }
          if (iteratee) {
            iteratee(group, array);
          } else {
            if (group.length > 0) {
              groups.push(group);
            }
          }
          i = i + j - 2;
        }
        if (iteratee) {
          return void 0;
        } else {
          return groups;
        }
      };
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
      firstKey = function(obj) {
        var _keys;
        _keys = keys(obj);
        if (_keys.length > 0) {
          return _keys[0];
        }
      };
      firstValue = function(obj) {
        var _keys;
        _keys = keys(obj);
        if (_keys.length > 0) {
          return obj[_keys[0]];
        }
      };
      return _.mixin({
        firstOf: firstOf,
        firstKey: firstKey,
        firstValue: firstValue,
        insertAt: insertAt,
        insertOneAt: insertOneAt,
        insertManyAt: insertManyAt,
        replaceAll: replaceAll,
        removeAt: removeAt,
        equalArrays: equalArrays,
        inGroupsOf: inGroupsOf
      });
    })();
    (function() {
      var applyWith, bindMethod, debounceMethod, isFunction, lodashBind, lodashDebounce, lodashOnce, mapMethod, onceMethod;
      isFunction = _.isFunction;
      lodashBind = _.bind;
      lodashDebounce = _.debounce;
      lodashOnce = _.once;
      applyWith = function(func, context, args) {
        var arg1, arg2, arg3, length;
        length = args.length;
        if (length > 0) {
          arg1 = args[0];
        }
        if (length > 1) {
          arg2 = args[1];
        }
        if (length > 2) {
          arg3 = args[2];
        }
        switch (length) {
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
      return _.mixin({
        applyWith: applyWith,
        onceMethod: onceMethod,
        bindMethod: bindMethod,
        debounceMethod: debounceMethod,
        mapMethod: mapMethod
      });
    })();
    (function() {
      var createObject, getProperty, setProperty, traverseObject;
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
      return _.mixin({
        createObject: createObject,
        traverseObject: traverseObject,
        setProperty: setProperty,
        getProperty: getProperty
      });
    })();
    (function() {
      var generateID, isEnabled;
      isEnabled = function(options, key) {
        return options !== false && (options != null ? options[key] : void 0) !== false;
      };
      generateID = (function() {
        var n;
        n = 0;
        return function() {
          return ++n;
        };
      })();
      return _.mixin({
        isEnabled: isEnabled,
        generateID: generateID
      });
    })();
    (function() {
      var eachToken;
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
      return _.mixin({
        eachToken: eachToken
      });
    })();
    (function() {
      var afterConstructor, afterFunction, afterMethod, beforeConstructor, beforeFunction, beforeMethod, copySuper, extend, insteadConstructor, overrideConstructor, overrideFunction, overrideMethod, wasConstructed;
      extend = _.extend;
      overrideFunction = function(original, overrides, type) {
        var _original, _overrides;
        _overrides = overrides;
        _original = original;
        return function() {
          var ret;
          switch (type != null ? type : 'before') {
            case 'before':
              _overrides.apply(this, arguments);
              ret = _original.apply(this, arguments);
              break;
            case 'after':
              ret = _original.apply(this, arguments);
              _overrides.apply(this, arguments);
          }
          return ret;
        };
      };
      overrideMethod = function(object, method, overrides, type) {
        return object[method] = overrideFunction(object[method], overrides, type);
      };
      overrideConstructor = function(original, overrides, type) {
        var _original, _overrides, overridden, prototype;
        _original = original;
        _overrides = overrides;
        prototype = _original.prototype;
        overridden = (type == null) || type === 'before' ? function() {
          _overrides.apply(this, arguments);
          _original.apply(this, arguments);
          return this;
        } : type === 'after' ? function() {
          _original.apply(this, arguments);
          _overrides.apply(this, arguments);
          return this;
        } : type === 'instead' ? function() {
          _overrides.apply(this, arguments);
          return this;
        } : void 0;
        extend(overridden, _original);
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
          copy = {};
          if (obj.__super__) {
            extend(copy, obj.__super__);
            copy.constructor = obj.__super__.constructor;
            copy.__proto__ = obj.__super__.__proto__;
          }
          obj.__super__ = copy;
          obj.superCopier = obj;
        }
        return obj.__super__;
      };
      wasConstructed = function(obj) {
        var ref;
        return (obj != null) && ((ref = obj.constructor) !== Object && ref !== Array && ref !== Number && ref !== String && ref !== Boolean);
      };
      return _.mixin({
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
        wasConstructed: wasConstructed,
        isClass: _.isFunction
      });
    })();
    (function() {
      var allowFunctions, baseReopen, clone, copySuper, createReopener, define, extend, hasOwnProp, isArray, isFunction, isObject, k, len1, len2, len3, m, name, o, pr, ref, ref1, ref2, reopeners, scope;
      isFunction = _.isFunction, isObject = _.isObject, isArray = _.isArray, extend = _.extend, clone = _.clone, copySuper = _.copySuper;
      hasOwnProp = {}.hasOwnProperty;
      baseReopen = function(Class, scope, allowFunctions, member, changes) {
        var arg, args, changesExist, classScope, i, instanceScope, isArrayValue, isDefinedValue, isObjectValue, length, members, ownerFlag, value;
        classScope = scope === 'ClassMembers';
        instanceScope = scope === 'InstanceMembers';
        members = classScope ? Class : Class.prototype;
        value = members[member];
        isDefinedValue = value != null;
        isObjectValue = isDefinedValue && isObject(value) && !isArray(value);
        isArrayValue = isDefinedValue && !isObjectValue && isArray(value);
        ownerFlag = "__" + member + "Owner";
        changesExist = arguments.length > 4;
        if (instanceScope && isDefinedValue) {
          copySuper(Class)[member] = value;
        }
        if (isObjectValue || isArrayValue) {
          if (classScope) {
            if (member[ownerFlag] !== Class) {
              member[ownerFlag] = Class;
              value = clone(value);
              members[member] = value;
            }
          } else if (!hasOwnProp.call(members, member)) {
            value = clone(value);
            members[member] = value;
          }
          if (changesExist) {
            if (allowFunctions && isFunction(changes)) {
              changes.call(value, value);
            } else if (isObject(changes) && !isArray(changes)) {
              if (isObjectValue) {
                extend(value, changes);
              } else if (isArrayValue) {
                value.push(changes);
              }
            } else if (isArrayValue) {
              args = [value.length, 0];
              i = 3;
              length = arguments.length;
              while (++i < length) {
                arg = arguments[i];
                if (isArray(arg)) {
                  args.push.apply(args, arg);
                } else {
                  args.push(arg);
                }
              }
              value.splice.apply(value, args);
            } else {
              members[member] = value = changes;
            }
          }
        } else if (changesExist) {
          members[member] = value = changes;
          if (classScope) {
            Class[ownerFlag] = Class;
          }
        }
        return value;
      };
      reopeners = {};
      createReopener = function(scope, allowFunctions) {
        var _allowFunctions, _scope;
        _scope = scope;
        _allowFunctions = allowFunctions;
        return function(Class, member, changes) {
          var args, i, len;
          len = arguments.length;
          i = 0;
          args = [Class, _scope, _allowFunctions];
          while (++i < len) {
            args.push(arguments[i]);
          }
          return baseReopen.apply(null, args);
        };
      };
      ref = ['InstanceMembers', 'ClassMembers'];
      for (k = 0, len1 = ref.length; k < len1; k++) {
        scope = ref[k];
        ref1 = [true, false];
        for (m = 0, len2 = ref1.length; m < len2; m++) {
          allowFunctions = ref1[m];
          name = "reopen" + (scope.slice(0, -1));
          if (allowFunctions) {
            name += 'With';
          }
          reopeners[name] = createReopener(scope, allowFunctions);
        }
      }
      reopeners.reopen = reopeners.reopenInstanceMember;
      reopeners.reopenWith = reopeners.reopenInstanceMemberWith;
      reopeners.reopenObject = function(Class, member) {
        var base;
        (base = Class.prototype)[member] || (base[member] = {});
        return reopeners.reopenInstanceMember.apply(reopeners, arguments);
      };
      reopeners.reopenArray = function(Class, member) {
        var base;
        (base = Class.prototype)[member] || (base[member] = []);
        return reopeners.reopenInstanceMember.apply(reopeners, arguments);
      };
      define = function(prop, func) {
        var _func;
        if (!Function.prototype[prop]) {
          _func = func;
          return Object.defineProperty(Function.prototype, prop, {
            value: function() {
              var args, i, length;
              length = arguments.length;
              i = -1;
              args = Array(length);
              while (++i < length) {
                args[i] = arguments[i];
              }
              args.unshift(this);
              return _func.apply(null, args);
            }
          });
        }
      };
      ref2 = ['reopen', 'reopenWith', 'reopenObject', 'reopenArray'];
      for (o = 0, len3 = ref2.length; o < len3; o++) {
        pr = ref2[o];
        define(pr, reopeners[pr]);
      }
      return _.mixin(reopeners);
    })();
  });

}).call(this);
