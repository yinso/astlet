class Environment
  constructor: () ->
    if not (@ instanceof Environment)
      return new Environment()
    Object.defineProperty @, 'inner',
      value: {}
      enumerable: false
      writable: false
  define: (name, val) ->
    if @has name
      throw new Error("Environment.define:duplicate_identifier: #{name}")
    @inner[name] = val
  has: (name) ->
    @inner.hasOwnProperty(name)
  set: (name, val) ->
    if not @has name
      throw new Error("Environment.set:unknown_identifier: #{name}")
    @inner[name] = val
  get: (name) ->
    if not @has name
      throw new Error("Environment.get:unknown_identifier: #{name}")
    @inner[name]

module.exports = Environment
