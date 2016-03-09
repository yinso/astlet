
class AST

AST.Integer = class Integer extends AST
  constructor: (value) ->
    if not (@ instanceof Integer)
      return new Integer(value)
    if typeof(value) == 'number'
      if Math.floor(value) == value
        Object.defineProperty @, 'value',
          value: value
      else
        throw new Error("AST.Integer:invalidValue: #{value}")
    else
        throw new Error("AST.Integer:invalidValue: #{value}")

AST.Float = class Float extends AST
  constructor: (value) ->
    if not (@ instanceof Float)
      return new Float(value)
    if typeof(value) == 'number'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.Float:invalidValue: #{value}")

AST.Boolean = class Boolean extends AST
  constructor: (value) ->
    if not (@ instanceof Boolean)
      return new Boolean(value)
    if typeof(value) == 'boolean'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.Boolean:invalidValue: #{value}")

AST.String = class String extends AST
  constructor: (value) ->
    if not (@ instanceof String)
      return new String(value)
    if typeof(value) == 'string'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.String:invalidValue: #{value}")

AST.Date = class ASTDate extends AST
  constructor: (value) ->
    if not (@ instanceof ASTDate)
      return new ASTDate value
    if value instanceof Date
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.Date:invalidValue: #{value}")

AST.Null = class Null extends AST
  constructor: () ->
    if not (@ instanceof Null)
      return new Null()

AST.Undefined = class Undefined extends AST
  constructor: () ->
    if not (@ instanceof Undefined)
      return new Undefined()

AST.Symbol = class Symbol extends AST
  constructor: (value) ->
    if not (@ instanceof Symbol)
      return new Symbol value
    if typeof(value) == 'string'
      Object.defineProperty @, 'value',
        value: value
    else
      throw new Error("AST.Symbol:invaidValue: #{value}")

AST.RegExp = class ASTRegExp extends AST
  constructor: (value) ->
    if not (@ instanceof ASTRegExp)
      return new ASTRegExp value
    if not (value instanceof RegExp)
      throw new Error("AST.RegExp:invalidValue: #{value}")
    Object.defineProperty @, 'value',
      value: value

AST.Parameter = class Parameter extends AST
  constructor: (name) ->
    if not (@ instanceof Parameter)
      return new Parameter name
    if not (name instanceof Symbol)
      throw new Error("AST.Parameter:invalidName: #{name}")
    Object.defineProperty @, 'name',
      value: name

AST.Array = class ASTArray extends AST
  constructor: (items) ->
    if not (@ instanceof ASTArray)
      return new ASTArray items
    if not (items instanceof Array)
      throw new Error("AST.Array:invalidItems:notArray: #{items}")
    for item, i in items
      if not (item instanceof AST)
        throw new Error("AST.Array:invalidItem:[#{i}]: #{item}")
    Object.defineProperty @, 'items',
      value: items

AST.Record = class Record extends AST
  constructor: (keyvals) ->
    if not (@ instanceof Record)
      return new Record keyvals
    if not (keyvals instanceof Array)
      throw new Error("AST.Record:invalidKeyVals:notArray: #{keyvals}")
    for keyval, i in keyvals
      if not (keyval instanceof Array)
        throw new Error("AST.Record:invalidKeyVal:[#{i}]: #{keyval}")
      if not ((keyval[0] instanceof AST.String) or (keyval[0] instanceof AST.Symbol))
        throw new Error("AST.Record:invalidKey:[#{i}]: #{keyval[0]}")
      if not (keyval[1] instanceof AST)
        throw new Error("AST.Record:invalidValue:[#{i}]: #{keyval[1]}")
    Object.defineProperty @, 'keyvals',
      value: keyvals

AST.MemberExp = class MemberExp extends AST
  constructor: (head, key) ->
    if not (@ instanceof MemberExp)
      return new MemberExp head, key
    if not (head instanceof AST)
      throw new Error("AST.MemberExp:invalidHead: #{head}")
    if not (key instanceof AST.Symbol)
      throw new Error("AST.MemberExp:invalidKey: #{key}")
    Object.defineProperties @,
      head:
        value: head
      key:
        value: key

AST.UnaryExp = class UnaryExp extends AST
  constructor: (op, rhs) ->
    if not (@ instanceof UnaryExp)
      return new UnaryExp op, rhs
    if not (op instanceof Symbol)
      throw new Error("AST.UnaryExp:invalidOperator: #{op}")
    if not (rhs instanceof AST)
      throw new Error("AST.UnaryExp:invalidRightHandSide: #{rhs}")
    Object.defineProperties @,
      op:
        value: op
      rhs:
        value: rhs

AST.BinaryExp = class BinaryExp extends AST
  constructor: (op, lhs, rhs) ->
    if not (@ instanceof BinaryExp)
      return new BinaryExp op, lhs, rhs
    if not (op instanceof Symbol)
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

AST.IfExp = class IfExp extends AST
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

AST.BlockExp = class BlockExp extends AST
  constructor: (body) ->
    if not (@ instanceof BlockExp)
      return new BlockExp body
    if not (body instanceof Array)
      throw new Error("AST.Block:invalidBody:notArray: #{body}")
    for exp, i in body
      if not (exp instanceof AST)
        throw new Error("AST.Block:invalidExpression:[#{i}]: #{exp}")
    Object.defineProperty @, 'body',
      value: body

AST.ProcedureCallExp = class ProcedureCallExp extends AST
  constructor: (proc, args) ->
    if not (@ instanceof ProcedureCallExp)
      return new ProcedureCallExp proc, args
    if not (proc instanceof AST)
      throw new Error("AST.ProcedureCallExp:invalidProcedure: #{proc}")
    if not (args instanceof Array)
      throw new Error("AST.ProcedureCallExp:invalidArgs:notArray: #{args}")
    for arg, i in args
      if not (arg instanceof AST)
        throw new Error("AST.ProcedureCallExp:invalidArg:[#{i}]: #{arg}")
    Object.defineProperties @,
      proc:
        value: proc
      args:
        value: args

AST.ProcedureExp = class ProcedureExp extends AST
  constructor: (name, args, body) ->
    if not (@ instanceof ProcedureExp)
      return new ProcedureExp name, args, body
    if arguments.length == 2
      body = args
      args = name
      name = null
    if not ((name == null) or (name instanceof AST.Symbol))
      throw new Error("AST.Procedure:invalidName: #{name}")
    if not (args instanceof Array)
      throw new Error("AST.Procedure:invalidArgs:notArray: #{args}")
    for arg, i in args
      if not (arg instanceof AST.Parameter)
        throw new Error("AST.Procedure:invalidArg:notParameter:[#{i}]: #{arg}")
    if not (body instanceof AST)
      throw new Error("AST.Procedure:invalidBody:notAST: #{body}")
    Object.defineProperties @,
      name:
        value: name
      args:
        value: args
      body:
        value: body
        
AST.DefineExp = class DefineExp extends AST
  constructor: (name, value) ->
    if not (@ instanceof DefineExp)
      return new DefineExp name, value
    if not (name instanceof AST.Symbol)
      throw new Error("AST.DefineExp:invalidName: #{name}")
    if not (value instanceof AST)
      throw new Error("AST.DefineExp:invalidValue: #{value}")
    Object.defineProperties @,
      name:
        value: name
      value:
        value: value

AST.AssignExp = class AssignExp extends AST
  constructor: (name, value) ->
    if not (@ instanceof AssignExp)
      return new AssignExp name, value
    if not (name instanceof AST.Symbol)
      throw new Error("AST.AssignExp:invalidName: #{name}")
    if not (value instanceof AST)
      throw new Error("AST.AssignExp:invalidValue: #{value}")
    Object.defineProperties @,
      name:
        value: name
      value:
        value: value

module.exports = AST

