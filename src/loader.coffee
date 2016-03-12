# Builder is used to load object-based syntax similar to JavaScript object tree.
AST = require './ast'


class Loader
  constructor: (env = AST.baseEnv) ->
    if not (@ instanceof Loader)
      return new Loader()
    Object.defineProperty @, 'env',
      value: env
      enumerable: false
      writable: false
  load: (obj) ->
    key = @key obj
    if Loader.prototype.hasOwnProperty(key)
      @[key](obj)
    else
      throw new Error("Loader.load:unknown_type: #{obj.type}")
  key: (obj) ->
    '_' + obj.type
  _integer: (obj) ->
    @env.get('integer') obj.value
  _float: (obj) ->
    @env.get('float') obj.value
  _boolean: (obj) ->
    AST.get('boolean') obj.value
  _string: (obj) ->
    AST.get('string') obj.value
  _date: (obj) ->
    AST.get('date') obj.value
  _null: (obj) ->
    AST.get('null')()
  _undefined: (obj) ->
    AST.get('undefined')()
  _symbol: (obj) ->
    AST.get('symbol') obj.value
  _regex: (obj) ->
    AST.get('regex') obj.value
  _parameter: (obj) ->
    name =
      if typeof(obj.name) == 'string'
        AST.get('symbol') obj.name
      else
        @load obj.name
    AST.get('param') name
  _array: (obj) ->
    items =
      for item in obj.items
        @load item
    AST.get('array') items
  _object: (obj) ->
    keyvals =
      for key, val of obj.properties
        [
          AST.get('symbol')(key)
          @load val
        ]
    AST.get('object') keyvals
  _member: (obj) ->
    head = @load obj.head
    key = @load obj.key
    AST.get('member') head, key
  _unary: (obj) ->
    op = @load obj.op
    rhs = @load obj.rhs
    AST.get('unary') op, rhs
  _binary: (obj) ->
    op = @load obj.op
    lhs = @load obj.lhs
    rhs = @load obj.rhs
    AST.get('binary') op, lhs, rhs
  _if: (obj) ->
    cond = @load obj.cond
    thenExp = @load obj.then
    elseExp = @load obj.else
    AST.get('if') cond, thenExp, elseExp
  _block: (obj) ->
    body =
      for exp in obj.body or []
        @load exp
    AST.get('block') body
  _procedureCall: (obj) ->
    proc = @load obj.proc
    args =
      for arg in obj.args or []
        @load arg
    AST.get('procedureCall') proc, args
  _procedure: (obj) ->
    name =
      if obj.name
        @load obj.name
      else
        null
    args =
      for arg in obj.args or []
        @load arg
    body = @load obj.body
    AST.get('procedure') name, args, body
  _define: (obj) ->
    name = @load obj.name
    value = @load obj.value
    AST.get('define') name, value
  _assign: (obj) ->
    name = @load obj.name
    value = @load obj.value
    AST.get('assign') name, value

AST.Loader = Loader

AST.load = (obj) ->
  loader = Loader()
  loader.load obj

module.exports = Loader
