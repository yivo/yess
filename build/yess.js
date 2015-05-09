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
  var applyWith, bindMethod, createObject, debounceMethod, eachToken, extend, generateId, insertAt, isArray, isEnabled, isFunction, lodashBind, lodashDebounce, mapMethod, nativeSlice, nativeSplice, onceMethod, removeAt, replaceAll, traverseObject, uniqueId,
      slice = [].slice;
    
    isArray = _.isArray;
    
    nativeSplice = Array.prototype.splice;
    
    nativeSlice = Array.prototype.slice;
    
    insertAt = function(container, items, pos) {
      var collection;
      collection = isArray(items) && items.length > 1;
      if (collection) {
        return nativeSplice.apply(container, [pos, 0].concat(items));
      } else {
        return nativeSplice.call(container, pos, 0, items[0] || items);
      }
    };
    
    replaceAll = function(container, items) {
      if (items && items.length) {
        return nativeSplice.apply(container, [0, container.length].concat(items));
      } else {
        return nativeSplice.call(container, 0, container.length);
      }
    };
    
    removeAt = function(container, pos, num) {
      if (num == null) {
        num = 1;
      }
      return nativeSplice.call(container, pos, num);
    };
    
    _.mixin({
      insertAt: insertAt,
      replaceAll: replaceAll,
      removeAt: removeAt,
      nativeSlice: nativeSlice,
      nativeSplice: nativeSplice
    });
    
    isFunction = _.isFunction, extend = _.extend;
    
    lodashBind = _.bind;
    
    lodashDebounce = _.debounce;
    
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
      return object[method] = lodashDebounce(lodashBind(object[method], object), time, options);
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
      var k, len1, method, methods, object, wrapper;
      object = arguments[0], methods = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      for (k = 0, len1 = methods.length; k < len1; k++) {
        method = methods[k];
        method = object[method];
        wrapper = (function(object, method) {
          var memo, run;
          run = false;
          memo = void 0;
          return function() {
            if (!run) {
              run = true;
              memo = method.apply(object, arguments);
              object = method = null;
            }
            return memo;
          };
        })(object, method);
        object[method] = wrapper;
      }
    };
    
    _.mixin({
      applyWith: applyWith,
      onceMethod: onceMethod,
      bindMethod: bindMethod,
      debounceMethod: debounceMethod,
      mapMethod: mapMethod
    });
    
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
            if (ret == null) {
              return ret;
            }
            j = 0;
          }
        } else {
          ++j;
        }
      }
      if (ret !== obj) {
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
    
    _.mixin({
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
    
});
