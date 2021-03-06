// Generated by CoffeeScript 1.10.0
(function() {
  var Environment;

  Environment = (function() {
    function Environment() {
      if (!(this instanceof Environment)) {
        return new Environment();
      }
      Object.defineProperty(this, 'inner', {
        value: {},
        enumerable: false,
        writable: false
      });
    }

    Environment.prototype.define = function(name, val) {
      if (this.has(name)) {
        throw new Error("Environment.define:duplicate_identifier: " + name);
      }
      return this.inner[name] = val;
    };

    Environment.prototype.has = function(name) {
      return this.inner.hasOwnProperty(name);
    };

    Environment.prototype.set = function(name, val) {
      if (!this.has(name)) {
        throw new Error("Environment.set:unknown_identifier: " + name);
      }
      return this.inner[name] = val;
    };

    Environment.prototype.get = function(name) {
      if (!this.has(name)) {
        throw new Error("Environment.get:unknown_identifier: " + name);
      }
      return this.inner[name];
    };

    return Environment;

  })();

  module.exports = Environment;

}).call(this);
