AST = require '../src/ast'

describe 'AST test', ->

  describe 'AST integer test', ->

    it 'can create Integer', ->
      v = AST.IntegerExp 10

    it 'can catch float ', (done)->
      try
        v = AST.IntegerExp 10.5
        done new Error("AST.Integer.float_past_thru")
      catch e
        done null
    
    it 'can catch non number', (done) ->
      try
        v = AST.IntegerExp 'not a number'
        done new Error("AST.Integer.string_past_thru")
      catch e
        done null

  describe 'Float test', ->

    it 'can create float', ->
      AST.FloatExp 10
      AST.FloatExp 10.5

    it 'can catch non float', (done) ->
      try
        AST.FloatExp 'not a number'
        done new Error("AST.Float:string_not_float")
      catch e
        done null

  describe 'Boolean test', ->

    it 'can create boolean', ->
      AST.BoolExp true
      AST.BoolExp false

    it 'can catch non bool', (done) ->
      try
        AST.BoolExp 1
        done new Error("AST.Boolean:not_boolean")
      catch e
        done null

  describe 'String test', ->

    it 'can create string ast', ->
      AST.StringExp 'this is a string'
    
    it 'can catch non string', (done) ->
      try
        AST.StringExp true
        done new Error("AST.String:not_a_string")
      catch e
        done null

  describe 'Date test', ->
    it 'can create date ast', ->
      AST.DateExp new Date()

    it 'can catch non date', (done) ->
      try
        AST.DateExp 'this is not a date'
        done new Error("AST.Date:not_a_date")
      catch e
        done null

  describe 'Null test', ->

    it 'can create null', ->
      AST.NullExp()

  describe 'Undefined test', ->
    it 'can create undefined', ->
      AST.UndefinedExp()


  describe 'Symbol test', ->
    it 'can create symbol', ->
      AST.SymbolExp 'a-symbol'

    it 'can catch non symbol', (done) ->
      try
        AST.SymbolExp 1
        done new Error("AST.Symbol:not_symbol")
      catch e
        done null

  describe 'RegExp test', ->
    it 'can create regexp', ->
      AST.RegExp /this is a regexp/

  describe 'Parameter test', ->
    it 'can create parameter', ->
      AST.ParameterExp AST.SymbolExp('foo')

  describe 'Array test', ->
    it 'can create array', ->
      AST.ArrayExp [
        AST.IntegerExp(1)
        AST.IntegerExp(2)
        AST.IntegerExp(3)
      ]

  describe 'Record test', ->
    it 'can create record (object)', ->
      AST.ObjectExp [
        [
          AST.SymbolExp('foo')
          AST.IntegerExp(1)
        ]
        [
          AST.SymbolExp('bar')
          AST.ArrayExp [
            AST.StringExp('hello')
            AST.StringExp('world')
          ]
        ]
      ]

  describe 'MemberExp test', ->
    it 'can create memberExp', ->
      AST.MemberExp AST.SymbolExp('test'), AST.SymbolExp('foo')

  describe 'UnaryExp test', ->
    it 'can create UnaryExp', ->
      AST.UnaryExp AST.SymbolExp('!'), AST.BoolExp(true)
    
  describe 'BinaryExp test', ->
    it 'can create BinaryExp', ->
      AST.BinaryExp AST.SymbolExp('+'), AST.FloatExp(1), AST.FloatExp(2.5)

  describe 'IfExp test', ->
    it 'can create IfExp', ->
      AST.IfExp AST.BoolExp(true), AST.IntegerExp(1), AST.IntegerExp(2)

  describe 'BlockExp test', ->
    it 'can create block', ->
      AST.BlockExp [
        AST.SymbolExp('foo')
        AST.BinaryExp(AST.SymbolExp('+'), AST.IntegerExp(1), AST.IntegerExp(2))
        AST.NullExp()
      ]

  describe 'ProcedureExp test', ->
    it 'can create procedure', ->
      AST.ProcedureExp AST.SymbolExp('add'),
        [
          AST.ParameterExp(AST.SymbolExp('a'))
          AST.ParameterExp(AST.SymbolExp('b'))
        ]
        AST.BinaryExp(AST.SymbolExp('+'), AST.SymbolExp('a'), AST.SymbolExp('b'))

  describe 'DefineExp test', ->
    it 'can create DefineExp', ->
      AST.DefineExp AST.SymbolExp('foo'), AST.IfExp(AST.BoolExp(true), AST.IntegerExp(1), AST.IntegerExp(2))

  describe 'AssignExp test', ->
    it 'can create DefineExp', ->
      AST.AssignExp AST.SymbolExp('foo'), AST.IfExp(AST.BoolExp(true), AST.IntegerExp(1), AST.IntegerExp(2))

  describe 'ProcedureCallExp test', ->
    it 'can create procedureCall', ->
      AST.ProcedureCallExp AST.SymbolExp('add'), [ AST.IntegerExp(1), AST.IntegerExp(2) ]


