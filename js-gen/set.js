// Generated by CoffeeScript 1.4.0
var Set,
  __slice = [].slice,
  __hasProp = {}.hasOwnProperty;

Set = (function() {

  function Set() {
    var e, elems, i, _i, _len, _ref;
    elems = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    this.elements = {};
    e = elems.length === 1 && typeof ((_ref = elems[0]) != null ? _ref.length : void 0) === 'number' ? elems[0] : elems;
    for (_i = 0, _len = e.length; _i < _len; _i++) {
      i = e[_i];
      this.elements[i] = i;
    }
  }

  Set.prototype.contains = function(e) {
    return this.elements.hasOwnProperty(e);
  };

  Set.prototype.add = function(e) {
    return this.elements[e] = e;
  };

  Set.prototype.remove = function(e) {
    return delete this.elements[e];
  };

  Set.prototype.first = function() {
    var e;
    for (e in this.elements) {
      return this.elements[e];
    }
  };

  Set.prototype.any = function(f) {
    var item, _ref;
    _ref = this.elements;
    for (item in _ref) {
      if (!__hasProp.call(_ref, item)) continue;
      if (f(this.elements[item])) {
        return true;
      }
    }
    return false;
  };

  Set.prototype.all = function(f) {
    var item, _ref;
    _ref = this.elements;
    for (item in _ref) {
      if (!__hasProp.call(_ref, item)) continue;
      if (!f(this.elements[item])) {
        return false;
      }
    }
    return true;
  };

  Set.prototype.filter = function(f) {
    var item, r, _ref;
    r = new Set();
    _ref = this.elements;
    for (item in _ref) {
      if (!__hasProp.call(_ref, item)) continue;
      if (f(this.elements[item])) {
        r.add(item);
      }
    }
    return r;
  };

  Set.prototype.map = function(f) {
    var item, r, _ref;
    r = new Set();
    _ref = this.elements;
    for (item in _ref) {
      if (!__hasProp.call(_ref, item)) continue;
      r.add(f(this.elements[item]));
    }
    return r;
  };

  Set.prototype.length = function() {
    return Object.keys(this.elements).length;
  };

  Set.prototype.findRandomElement = function() {
    var i, idx, item, _ref;
    idx = Math.floor(Math.random() * Object.keys(this.elements).length);
    i = 0;
    _ref = this.elements;
    for (item in _ref) {
      if (!__hasProp.call(_ref, item)) continue;
      if (i === idx) {
        return item;
      }
      i += 1;
    }
  };

  Set.prototype.toString = function() {
    var i, s, _ref;
    s = 'Set(';
    _ref = this.elements;
    for (i in _ref) {
      if (!__hasProp.call(_ref, i)) continue;
      s += s === 'Set(' ? '' : ', ';
      s += i;
    }
    return s + ')';
  };

  return Set;

})();
