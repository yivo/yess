(function() {
  var slice1 = [].slice;

  (function(root, factory) {
    if (typeof define === 'function' && define.amd) {
      return define(['lodash'], function(_) {
        return root.yess = factory(root, _);
      });
    } else if (typeof module === 'object' && typeof module.exports === 'object') {
      return module.exports = factory(root, require('lodash'));
    } else {
      return root.yess = factory(root, root._);
    }
  })(this, function(root, _) {
    var apply, bind, createObject, debounce, extend, generateId, insertAt, isArray, isEnabled, isFunction, lodashBind, lodashDebounce, mapMethod, once, removeAt, replaceAll, slice, splice, traverseObject, uniqueId, yess;
    yess = {};
    isArray = _.isArray, extend = _.extend;
    splice = Array.prototype.splice;
    slice = Array.prototype.slice;
    insertAt = function(container, items, pos) {
      var many;
      many = isArray(items) && items.length > 1;
      if (many) {
        return splice.apply(container, [pos, 0].concat(items));
      } else {
        return splice.call(container, pos, 0, items[0] || items);
      }
    };
    replaceAll = function(container, items) {
      if (items && items.length) {
        return splice.apply(container, [0, container.length].concat(items));
      } else {
        return splice.call(container, 0, container.length);
      }
    };
    removeAt = function(container, pos, num) {
      if (num == null) {
        num = 1;
      }
      return splice.call(container, pos, num);
    };
    extend(yess, {
      insertAt: insertAt,
      replaceAll: replaceAll,
      removeAt: removeAt,
      slice: slice,
      splice: splice
    });
    isFunction = _.isFunction, extend = _.extend;
    lodashBind = _.bind;
    lodashDebounce = _.debounce;
    apply = function(func, obj, args) {
      var arg1, arg2, arg3;
      arg1 = args[0];
      arg2 = args[1];
      arg3 = args[2];
      switch (args.length) {
        case 0:
          return func.call(obj);
        case 1:
          return func.call(obj, arg1);
        case 2:
          return func.call(obj, arg1, arg2);
        case 3:
          return func.call(obj, arg1, arg2, arg3);
        default:
          return func.apply(obj, args);
      }
    };
    mapMethod = function(object, method) {
      if (isFunction(method)) {
        return method;
      } else {
        return object && object[method];
      }
    };
    debounce = function(object, method, time, options) {
      return object[method] = lodashDebounce(lodashBind(object[method], object), time, options);
    };
    bind = function() {
      var k, len1, method, methods, object;
      object = arguments[0], methods = 2 <= arguments.length ? slice1.call(arguments, 1) : [];
      for (k = 0, len1 = methods.length; k < len1; k++) {
        method = methods[k];
        object[method] = lodashBind(object[method], object);
      }
    };
    once = function() {
      var k, len1, method, methods, object, real, wrapper;
      object = arguments[0], methods = 2 <= arguments.length ? slice1.call(arguments, 1) : [];
      for (k = 0, len1 = methods.length; k < len1; k++) {
        method = methods[k];
        real = object[method];
        wrapper = (function(object, real) {
          var memo, run;
          run = false;
          memo = void 0;
          return function() {
            if (!run) {
              run = true;
              memo = real.apply(object, arguments);
              object = null;
              real = null;
            }
            return memo;
          };
        })(object, real);
        object[method] = wrapper;
      }
    };
    extend(yess, {
      apply: apply,
      once: once,
      bind: bind,
      debounce: debounce,
      mapMethod: mapMethod
    });
    extend = _.extend;
    traverseObject = function(obj, path) {
      var i, j, len, ret;
      ret = obj;
      len = path.length;
      i = -1;
      j = 0;
      while (++i <= len) {
        if (i === len || path[i] === '.') {
          if (j > 0) {
            ret = ret[path.slice(i - j, i)];
            if (!ret) {
              return ret;
            }
            j = 0;
          }
        } else {
          ++j;
        }
      }
      if (ret === obj) {
        return void 0;
      } else {
        return ret;
      }
    };
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
    extend(yess, {
      traverseObject: traverseObject,
      createObject: createObject
    });
    extend = _.extend, uniqueId = _.uniqueId;
    isEnabled = function(options, option) {
      return !options || options[option] === void 0 || !!options[option];
    };
    generateId = function() {
      return +uniqueId();
    };
    extend(yess, {
      isEnabled: isEnabled,
      generateId: generateId
    });
    return yess;
  });

}).call(this);
