
Environment = require './env'

class AST
  Object.defineProperties @,
    Environment:
      value: Environment
    baseEnv:
      value: new Environment()
  @define: (ctor) ->
    name = ctor.type
    @baseEnv.define name, ctor
    #Object.defineProperty @, name,
    #  value: ctor
    #  writable: false
  @get: (name) ->
    @baseEnv.get name

AST.define class IntegerExp extends AST
  @type: 'integer'
  constructor: (value) ->
    if not (@ instanceof IntegerExp)
      return new IntegerExp(value)
    if typeof(value) == 'number'
      if Math.floor(value) == value
        Object.defineProperty @, 'value',
          value: value
      else
        throw new Error("AST.IntegerExp:invalidValue: #{value}")
    else
        throw new Error("AST.IntegerExp:invalidValue: #{value}")

AST.define class FloatExp extends AST
  @type: 'float' # should I change to number?
  constructor: (value) ->
    if not (@ instanceof FloatExp)
      return new FloatExp(value)
    if typeof(value) == 'number'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.FloatExp:invalidValue: #{value}")

AST.define class BoolExp extends AST
  @type: 'boolean'
  constructor: (value) ->
    if not (@ instanceof BoolExp)
      return new BoolExp(value)
    if typeof(value) == 'boolean'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.BoolExp:invalidValue: #{value}")

AST.define class StringExp extends AST
  @type: 'string'
  constructor: (value) ->
    if not (@ instanceof StringExp)
      return new StringExp(value)
    if typeof(value) == 'string'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.StringExp:invalidValue: #{value}")

AST.define class DateExp extends AST
  @type: 'date'
  constructor: (value) ->
    if not (@ instanceof DateExp)
      return new DateExp value
    if value instanceof Date
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.DateExp:invalidValue: #{value}")

AST.define class NullExp extends AST
  @type: 'null'
  constructor: () ->
    if not (@ instanceof NullExp)
      return new NullExp()

AST.define class UndefinedExp extends AST
  @type: 'undefined'
  constructor: () ->
    if not (@ instanceof UndefinedExp)
      return new UndefinedExp()

AST.define class SymbolExp extends AST
  @type: 'symbol'
  constructor: (value) ->
    if not (@ instanceof SymbolExp)
      return new SymbolExp value
    if typeof(value) == 'string'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.SymbolExp:invaidValue: #{value}")

AST.define class ASTRegExp extends AST
  @type: 'regex'
  constructor: (value) ->
    if not (@ instanceof ASTRegExp)
      return new ASTRegExp value
    if not (value instanceof RegExp)
      throw new Error("AST.RegExp:invalidValue: #{value}")
    Object.defineProperty @, 'value',
      value: value

AST.define class ParameterExp extends AST
  @type: 'param'
  constructor: (name) ->
    if not (@ instanceof ParameterExp)
      return new ParameterExp name
    if not (name instanceof AST.get('symbol'))
      throw new Error("AST.ParameterExp:invalidName: #{name}")
    Object.defineProperty @, 'name',
      value: name

AST.define class ArrayExp extends AST
  @type: 'array'
  constructor: (items) ->
    if not (@ instanceof ArrayExp)
      return new ArrayExp items
    if not (items instanceof Array)
      throw new Error("AST.ArrayExp:invalidItems:notArrayExp: #{items}")
    for item, i in items
      if not (item instanceof AST)
        throw new Error("AST.ArrayExp:invalidItem:[#{i}]: #{item}")
    Object.defineProperty @, 'items',
      value: items

AST.define class ObjectExp extends AST
  @type: 'object'
  constructor: (keyvals) ->
    if not (@ instanceof ObjectExp)
      return new ObjectExp keyvals
    if not (keyvals instanceof Array)
      throw new Error("AST.ObjectExp:invalidKeyVals:notArrayExp: #{keyvals}")
    for keyval, i in keyvals
      if not (keyval instanceof Array)
        throw new Error("AST.ObjectExp:invalidKeyVal:[#{i}]: #{keyval}")
      if not ((keyval[0] instanceof AST.get('string')) or (keyval[0] instanceof AST.get('symbol')))
        throw new Error("AST.ObjectExp:invalidKey:[#{i}]: #{keyval[0]}")
      if not (keyval[1] instanceof AST)
        throw new Error("AST.ObjectExp:invalidValue:[#{i}]: #{keyval[1]}")
    Object.defineProperty @, 'properties',
      value: keyvals

AST.define class MemberExp extends AST
  @type: 'member'
  constructor: (head, key) ->
    if not (@ instanceof MemberExp)
      return new MemberExp head, key
    if not (head instanceof AST)
      throw new Error("AST.MemberExp:invalidHead: #{head}")
    if not (key instanceof AST.get('symbol'))
      throw new Error("AST.MemberExp:invalidKey: #{key}")
    Object.defineProperties @,
      head:
        value: head
      key:
        value: key

AST.define class UnaryExp extends AST
  @type: 'unary'
  constructor: (op, rhs) ->
    if not (@ instanceof UnaryExp)
      return new UnaryExp op, rhs
    if not (op instanceof AST.get('symbol'))
      throw new Error("AST.UnaryExp:invalidOperator: #{op}")
    if not (rhs instanceof AST)
      throw new Error("AST.UnaryExp:invalidRightHandSide: #{rhs}")
    Object.defineProperties @,
      op:
        value: op
      rhs:
        value: rhs

AST.define class BinaryExp extends AST
  @type: 'binary'
  constructor: (op, lhs, rhs) ->
    if not (@ instanceof BinaryExp)
      return new BinaryExp op, lhs, rhs
    if not (op instanceof AST.get('symbol'))
      throw new Error("AST.BinaryExp:invalidOperator: #{op}")
    if not (lhs instanceof AST)
      throw new Error("AST.BinaryExp:invalidLefttHandSide: #{lhs}")
    if not (rhs instanceof AST)
      throw new Error("AST.BinaryExp:invalidRightHandSide: #{rhs}")
    Object.defineProperties @,
      op:
        value: op
      lhs:
        value: lhs
      rhs:
        value: rhs

AST.define class IfExp extends AST
  @type: 'if'
  constructor: (cond, thenExp, elseExp) ->
    if not (@ instanceof IfExp)
      return new IfExp cond, thenExp, elseExp
    if not (cond instanceof AST)
      throw new Error("AST.If:invalidCond: #{cond}")
    if not (thenExp instanceof AST)
      throw new Error("AST.If:invalidThen: #{thenExp}")
    if not (elseExp instanceof AST)
      throw new Error("AST.If:invalidElse: #{elseExp}")
    Object.defineProperties @,
      cond:
        value: cond
      then:
        value: thenExp
      else:
        value: elseExp

AST.define class BlockExp extends AST
  @type: 'block'
  constructor: (body) ->
    if not (@ instanceof BlockExp)
      return new BlockExp body
    if not (body instanceof Array)
      throw new Error("AST.Block:invalidBody:notArrayExp: #{body}")
    for exp, i in body
      if not (exp instanceof AST)
        throw new Error("AST.Block:invalidExpression:[#{i}]: #{exp}")
    Object.defineProperty @, 'body',
      value: body

AST.define class ProcedureCallExp extends AST
  @type: 'procedureCall'
  constructor: (proc, args) ->
    if not (@ instanceof ProcedureCallExp)
      return new ProcedureCallExp proc, args
    if not (proc instanceof AST)
      throw new Error("AST.ProcedureCallExp:invalidProcedure: #{proc}")
    if not (args instanceof Array)
      throw new Error("AST.ProcedureCallExp:invalidArgs:notArrayExp: #{args}")
    for arg, i in args
      if not (arg instanceof AST)
        throw new Error("AST.ProcedureCallExp:invalidArg:[#{i}]: #{arg}")
    Object.defineProperties @,
      proc:
        value: proc
      args:
        value: args

AST.define class ProcedureExp extends AST
  @type: 'procedure'
  constructor: (name, args, body) ->
    if not (@ instanceof ProcedureExp)
      return new ProcedureExp name, args, body
    if arguments.length == 2
      body = args
      args = name
      name = null
    if not ((name == null) or (name instanceof AST.get('symbol')))
      throw new Error("AST.Procedure:invalidName: #{name}")
    if not (args instanceof Array)
      throw new Error("AST.Procedure:invalidArgs:notArrayExp: #{args}")
    for arg, i in args
      if not (arg instanceof AST.get('param'))
        throw new Error("AST.Procedure:invalidArg:notParameterExp:[#{i}]: #{arg}")
    if not (body instanceof AST)
      throw new Error("AST.Procedure:invalidBody:notAST: #{body}")
    Object.defineProperties @,
      name:
        value: name
      args:
        value: args
      body:
        value: body

AST.define class DefineExp extends AST
  @type: 'define'
  constructor: (name, value) ->
    if not (@ instanceof DefineExp)
      return new DefineExp name, value
    if not (name instanceof AST.get('symbol'))
      throw new Error("AST.DefineExp:invalidName: #{name}")
    if not (value instanceof AST)
      throw new Error("AST.DefineExp:invalidValue: #{value}")
    Object.defineProperties @,
      name:
        value: name
      value:
        value: value

AST.define class AssignExp extends AST
  @type: 'assign'
  constructor: (name, value) ->
    if not (@ instanceof AssignExp)
      return new AssignExp name, value
    if not (name instanceof AST.get('symbol'))
      throw new Error("AST.AssignExp:invalidName: #{name}")
    if not (value instanceof AST)
      throw new Error("AST.AssignExp:invalidValue: #{value}")
    Object.defineProperties @,
      name:
        value: name
      value:
        value: value

module.exports = AST
