AST = require '../src/ast'

describe 'AST test', ->

  describe 'AST integer test', ->

    it 'can create Integer', ->
      v = AST.Integer 10

    it 'can catch float ', (done)->
      try
        v = AST.Integer 10.5
        done new Error("AST.Integer.float_past_thru")
      catch e
        done null
    
    it 'can catch non number', (done) ->
      try
        v = AST.Integer 'not a number'
        done new Error("AST.Integer.string_past_thru")
      catch e
        done null

  describe 'Float test', ->

    it 'can create float', ->
      AST.Float 10
      AST.Float 10.5

    it 'can catch non float', (done) ->
      try
        AST.Float 'not a number'
        done new Error("AST.Float:string_not_float")
      catch e
        done null

  describe 'Boolean test', ->

    it 'can create boolean', ->
      AST.Boolean true
      AST.Boolean false

    it 'can catch non bool', (done) ->
      try
        AST.Boolean 1
        done new Error("AST.Boolean:not_boolean")
      catch e
        done null

  describe 'String test', ->

    it 'can create string ast', ->
      AST.String 'this is a string'
    
    it 'can catch non string', (done) ->
      try
        AST.String true
        done new Error("AST.String:not_a_string")
      catch e
        done null

  describe 'Date test', ->
    it 'can create date ast', ->
      AST.Date new Date()

    it 'can catch non date', (done) ->
      try
        AST.Date 'this is not a date'
        done new Error("AST.Date:not_a_date")
      catch e
        done null

  describe 'Null test', ->

    it 'can create null', ->
      AST.Null()

  describe 'Undefined test', ->
    it 'can create undefined', ->
      AST.Undefined()


  describe 'Symbol test', ->
    it 'can create symbol', ->
      AST.Symbol 'a-symbol'

    it 'can catch non symbol', (done) ->
      try
        AST.Symbol 1
        done new Error("AST.Symbol:not_symbol")
      catch e
        done null

  describe 'RegExp test', ->
    it 'can create regexp', ->
      AST.RegExp /this is a regexp/

  describe 'Parameter test', ->
    it 'can create parameter', ->
      AST.Parameter AST.Symbol('foo')

  describe 'Array test', ->
    it 'can create array', ->
      AST.Array [
        AST.Integer(1)
        AST.Integer(2)
        AST.Integer(3)
      ]

  describe 'Record test', ->
    it 'can create record (object)', ->
      AST.Record [
        [
          AST.Symbol('foo')
          AST.Integer(1)
        ]
        [
          AST.Symbol('bar')
          AST.Array [
            AST.String('hello')
            AST.String('world')
          ]
        ]
      ]

  describe 'MemberExp test', ->
    it 'can create memberExp', ->
      AST.MemberExp AST.Symbol('test'), AST.Symbol('foo')

  describe 'UnaryExp test', ->
    it 'can create UnaryExp', ->
      AST.UnaryExp AST.Symbol('!'), AST.Boolean(true)
    
  describe 'BinaryExp test', ->
    it 'can create BinaryExp', ->
      AST.BinaryExp AST.Symbol('+'), AST.Float(1), AST.Float(2.5)

  describe 'IfExp test', ->
    it 'can create IfExp', ->
      AST.IfExp AST.Boolean(true), AST.Integer(1), AST.Integer(2)

  describe 'BlockExp test', ->
    it 'can create block', ->
      AST.BlockExp [
        AST.Symbol('foo')
        AST.BinaryExp(AST.Symbol('+'), AST.Integer(1), AST.Integer(2))
        AST.Null()
      ]

  describe 'ProcedureExp test', ->
    it 'can create procedure', ->
      AST.ProcedureExp AST.Symbol('add'),
        [
          AST.Parameter(AST.Symbol('a'))
          AST.Parameter(AST.Symbol('b'))
        ]
        AST.BinaryExp(AST.Symbol('+'), AST.Symbol('a'), AST.Symbol('b'))

  describe 'DefineExp test', ->
    it 'can create DefineExp', ->
      AST.DefineExp AST.Symbol('foo'), AST.IfExp(AST.Boolean(true), AST.Integer(1), AST.Integer(2))

  describe 'AssignExp test', ->
    it 'can create DefineExp', ->
      AST.AssignExp AST.Symbol('foo'), AST.IfExp(AST.Boolean(true), AST.Integer(1), AST.Integer(2))

  describe 'ProcedureCallExp test', ->
    it 'can create procedureCall', ->
      AST.ProcedureCallExp AST.Symbol('add'), [ AST.Integer(1), AST.Integer(2) ]


