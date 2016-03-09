# Builder is used to load object-based syntax similar to JavaScript object tree.
AST = require './ast'


class Loader
  constructor: () ->
    if not (@ instanceof Loader)
      return new Loader()
  load: (obj) ->
    key = @key obj
    if Loader.prototype.hasOwnProperty(key)
      @[key](obj)
    else
      throw new Error("Loader.load:unknown_type: #{obj.type}")
  key: (obj) ->
    '_' + obj.type
  _integer: (obj) ->
    AST.Integer obj.value
  _float: (obj) ->
    AST.Float obj.value
  _boolean: (obj) ->
    AST.Boolean obj.value
  _string: (obj) ->
    AST.String obj.value
  _date: (obj) ->
    AST.Date obj.value
  _null: (obj) ->
    AST.Null()
  _undefined: (obj) ->
    AST.Undefined()
  _symbol: (obj) ->
    AST.Symbol obj.value
  _regex: (obj) ->
    AST.RegExp obj.value
  _parameter: (obj) ->
    name =
      if typeof(obj.name) == 'string'
        AST.Symbol obj.name
      else
        @load obj.name
    AST.Parameter name
  _array: (obj) ->
    items =
      for item in obj.items
        @load item
    AST.Array items
  _object: (obj) ->
    keyvals =
      for key, val of obj.properties
        [
          AST.Symbol(key)
          @load val
        ]
    AST.Record keyvals
  _member: (obj) ->
    head = @load obj.head
    key = @load obj.key
    AST.MemberExp head, key
  _unary: (obj) ->
    op = @load obj.op
    rhs = @load obj.rhs
    AST.UnaryExp op, rhs
  _binary: (obj) ->
    op = @load obj.op
    lhs = @load obj.lhs
    rhs = @load obj.rhs
    AST.BinaryExp op, lhs, rhs
  _if: (obj) ->
    cond = @load obj.cond
    thenExp = @load obj.then
    elseExp = @load obj.else
    AST.IfExp cond, thenExp, elseExp
  _block: (obj) ->
    body =
      for exp in obj.body or []
        @load exp
    AST.BlockExp body
  _procedureCall: (obj) ->
    proc = @load obj.proc
    args =
      for arg in obj.args or []
        @load arg
    AST.ProcedureCallExp proc, args
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
    AST.ProcedureExp name, args, body
  _define: (obj) ->
    name = @load obj.name
    value = @load obj.value
    AST.DefineExp name, value
  _assign: (obj) ->
    name = @load obj.name
    value = @load obj.value
    AST.AssignExp name, value

AST.Loader = Loader

module.exports = Loader

