AST = require '../src/ast'

describe 'AST test', ->

  describe 'AST integer test', ->

    it 'can create Integer', ->
      v = AST.get('integer') 10

    it 'can catch float ', (done)->
      try
        v = AST.get('integer') 10.5
        done new Error("AST.Integer.float_past_thru")
      catch e
        done null

    it 'can catch non number', (done) ->
      try
        v = AST.get('integer') 'not a number'
        done new Error("AST.Integer.string_past_thru")
      catch e
        done null

  describe 'Float test', ->

    it 'can create float', ->
      AST.get('float') 10
      AST.get('float') 10.5

    it 'can catch non float', (done) ->
      try
        AST.get('float') 'not a number'
        done new Error("AST.Float:string_not_float")
      catch e
        done null

  describe 'Boolean test', ->

    it 'can create boolean', ->
      AST.get('boolean') true
      AST.get('boolean') false

    it 'can catch non bool', (done) ->
      try
        AST.get('boolean') 1
        done new Error("AST.Boolean:not_boolean")
      catch e
        done null

  describe 'String test', ->

    it 'can create string ast', ->
      AST.get('string') 'this is a string'

    it 'can catch non string', (done) ->
      try
        AST.get('string') true
        done new Error("AST.get('string'):not_a_string")
      catch e
        done null

  describe 'Date test', ->
    it 'can create date ast', ->
      AST.get('date') new Date()

    it 'can catch non date', (done) ->
      try
        AST.get('date') 'this is not a date'
        done new Error("AST.Date:not_a_date")
      catch e
        done null

  describe 'Null test', ->

    it 'can create null', ->
      AST.get('null')()

  describe 'Undefined test', ->
    it 'can create undefined', ->
      AST.get('undefined')()


  describe 'Symbol test', ->
    it 'can create symbol', ->
      AST.get('symbol') 'a-symbol'

    it 'can catch non symbol', (done) ->
      try
        AST.get('symbol') 1
        done new Error("AST.Symbol:not_symbol")
      catch e
        done null

  describe 'Regex test', ->
    it 'can create regex', ->
      AST.get('regex') /this is a get('regex')/

  describe 'Parameter test', ->
    it 'can create parameter', ->
      AST.get('param') AST.get('symbol')('foo')

  describe 'Array test', ->
    it 'can create array', ->
      AST.get('array') [
        AST.get('integer')(1)
        AST.get('integer')(2)
        AST.get('integer')(3)
      ]

  describe 'Record test', ->
    it 'can create record (object)', ->
      AST.get('object') [
        [
          AST.get('symbol')('foo')
          AST.get('integer')(1)
        ]
        [
          AST.get('symbol')('bar')
          AST.get('array') [
            AST.get('string')('hello')
            AST.get('string')('world')
          ]
        ]
      ]

  describe 'MemberExp test', ->
    it 'can create MemberExp', ->
      AST.get('member') AST.get('symbol')('test'), AST.get('symbol')('foo')

  describe 'UnaryExp test', ->
    it 'can create UnaryExp', ->
      AST.get('unary') AST.get('symbol')('!'), AST.get('boolean')(true)

  describe 'BinaryExp test', ->
    it 'can create BinaryExp', ->
      AST.get('binary') AST.get('symbol')('+'), AST.get('float')(1), AST.get('float')(2.5)

  describe 'IfExp test', ->
    it 'can create IfExp', ->
      AST.get('if') AST.get('boolean')(true), AST.get('integer')(1), AST.get('integer')(2)

  describe 'BlockExp test', ->
    it 'can create block', ->
      AST.get('block') [
        AST.get('symbol')('foo')
        AST.get('binary')(AST.get('symbol')('+'), AST.get('integer')(1), AST.get('integer')(2))
        AST.get('null')()
      ]

  describe 'ProcedureExp test', ->
    it 'can create procedure', ->
      AST.get('procedure') AST.get('symbol')('add'),
        [
          AST.get('param')(AST.get('symbol')('a'))
          AST.get('param')(AST.get('symbol')('b'))
        ]
        AST.get('binary')(AST.get('symbol')('+'), AST.get('symbol')('a'), AST.get('symbol')('b'))

  describe 'DefineExp test', ->
    it 'can create DefineExp', ->
      AST.get('define') AST.get('symbol')('foo'), AST.get('if')(AST.get('boolean')(true), AST.get('integer')(1), AST.get('integer')(2))

  describe 'AssignExp test', ->
    it 'can create AssignExp', ->
      AST.get('assign') AST.get('symbol')('foo'), AST.get('if')(AST.get('boolean')(true), AST.get('integer')(1), AST.get('integer')(2))

  describe 'ProcedureCallExp test', ->
    it 'can create procedureCall', ->
      AST.get('procedureCall') AST.get('symbol')('add'), [ AST.get('integer')(1), AST.get('integer')(2) ]
