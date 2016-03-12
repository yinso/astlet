Environment = require '../src/env'
{ assert } = require 'chai'

describe 'environment test', ->

  env = null

  it 'can create env', ->
    env = new Environment()

  it 'can define value', ->
    env.define 'foo', 1

  it 'can throw when redefine value', ->
    assert.throws ->
      env.define 'foo', 2

  it 'can set once defined', ->
    env.set 'foo', 2
    env.set 'foo', 1

  it 'cannot set unknown name', ->
    assert.throws ->
      env.set 'bar', 2

  it 'can check if name exists', ->
    assert.ok env.has 'foo'

  it 'can check if name does not exist', ->
    assert.notOk env.has 'bar'

  it 'can get value', ->
    assert.equal 1, env.get 'foo'

  it 'can throw when not found', ->
    assert.throws ->
      env.get 'bar'
