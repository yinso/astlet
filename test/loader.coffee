Loader = require '../src/loader'
AST = require '../src/ast'
{ assert } = require 'chai'

describe 'loader test', ->

  loader = Loader()

  it 'can load integer', ->
    ast = loader.load
      type: 'integer'
      value: 1
    assert.ok ast instanceof AST.get('integer')

  it 'can load float', ->
    ast = loader.load
      type: 'float'
      value: 1.5
    assert.ok ast instanceof AST.get('float')

  it 'can load bool', ->
    ast = loader.load
      type: 'boolean'
      value: true
    assert.ok ast instanceof AST.get('boolean')

  it 'can load string', ->
    ast = loader.load
      type: 'string'
      value: 'this is a string'
    assert.ok ast instanceof AST.get('string')

  it 'can load date', ->
    ast = loader.load
      type: 'date'
      value: new Date()
    assert.ok ast instanceof AST.get('date')

  it 'can load null', ->
    ast = loader.load
      type: 'null'
    assert.ok ast instanceof AST.get('null')

  it 'can load undefined', ->
    ast = loader.load
      type: 'undefined'
    assert.ok ast instanceof AST.get('undefined')

  it 'can load symbol', ->
    ast = loader.load
      type: 'symbol'
      value: 'foo'
    assert.ok ast instanceof AST.get('symbol')

  it 'can load regex', ->
    ast = loader.load
      type: 'regex'
      value: /this is regex/
    assert.ok ast instanceof AST.get('regex')


  it 'can load parameter', ->
    ast = loader.load
      type: 'parameter'
      name: 'foo'
    assert.ok ast instanceof AST.get('param')

  it 'can load array', ->
    ast = loader.load
      type: 'array'
      items: [
        {
          type: 'integer'
          value: 1
        }
        {
          type: 'integer'
          value: 10
        }
      ]
    assert.ok ast instanceof AST.get('array')


  it 'can load object', ->
    ast = loader.load
      type: 'object'
      properties:
        foo:
          type: 'integer'
          value: 1
        bar:
          type: 'string'
          value: 'hello'
        baz:
          type: 'object'
          properties:
            xyz:
              type: 'boolean'
              value: false
            pattern:
              type: 'regex'
              value: /\d+/
    assert.ok ast instanceof AST.get('object')

  it 'can load member', ->
    ast = loader.load
      type: 'member'
      head:
        type: 'symbol'
        value: 'foo'
      key:
        type: 'symbol'
        value: 'bar'
    assert.ok ast instanceof AST.get('member')

  it 'can load unary', ->
    ast = loader.load
      type: 'unary'
      op:
        type: 'symbol'
        value: '!'
      rhs:
        type: 'symbol'
        value: 'foo'
    assert.ok ast instanceof AST.get('unary')

  it 'can load binary', ->
    ast = loader.load
      type: 'binary'
      op:
        type: 'symbol'
        value: '+'
      lhs:
        type: 'integer'
        value: 1
      rhs:
        type: 'symbol'
        value: 'b'
    assert.ok ast instanceof AST.get('binary')

  it 'can load if', ->
    ast = loader.load
      type: 'if'
      cond:
        type: 'boolean'
        value: true
      then:
        type: 'string'
        value: 'hello'
      else:
        type: 'integer'
        value: 2
    assert.ok ast instanceof AST.get('if')

  it 'can load block', ->
    ast = loader.load
      type: 'block'
      body: [
        {
          type: 'integer'
          value: 1
        }
        {
          type: 'binary'
          op:
            type: 'symbol'
            value: '+'
          lhs:
            type: 'symbol'
            value: 'foo'
          rhs:
            type: 'symbol'
            value: 'bar'
        }
      ]
    assert.ok ast instanceof AST.get('block')

  it 'can load procedure call', ->
    ast = loader.load
      type: 'procedureCall'
      proc:
        type: 'symbol'
        value: 'add'
      args: [
        {
          type: 'float'
          value: 1
        }
        {
          type: 'float'
          value: 2
        }
      ]
    assert.ok ast instanceof AST.get('procedureCall')

  it 'can load procedure', ->
    ast = loader.load
      type: 'procedure'
      name:
        type: 'symbol'
        value: 'add'
      args: [
        {
          type: 'parameter'
          name: 'a'
        }
        {
          type: 'parameter'
          name: 'b'
        }
      ]
      body:
        type: 'binary'
        op:
          type: 'symbol'
          value: '+'
        lhs:
          type: 'symbol'
          value: 'a'
        rhs:
          type: 'symbol'
          value: 'b'
    assert.ok ast instanceof AST.get('procedure')

  it 'can load define', ->
    ast = loader.load
      type: 'define'
      name:
        type: 'symbol'
        value: 'foo'
      value:
        type: 'string'
        value: 'hello'
    assert.ok ast instanceof AST.get('define')

  it 'can load assign', ->
    ast = loader.load
      type: 'assign'
      name:
        type: 'symbol'
        value: 'foo'
      value:
        type: 'string'
        value: 'hello'
    assert.ok ast instanceof AST.get('assign')
