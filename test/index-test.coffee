chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
fs.cwd          = process.cwd
inherits        = require 'inherits-ex/lib/inherits'
extend          = require 'util-ex/lib/_extend'
File            = require '../src'

setImmediate    = setImmediate || process.nextTick

describe 'CustomFile', ->
  it 'should not create an file object if path invalid', ->
    should.throw File.bind(null, cwd: '/path/dff', path: 'path')
  it 'should create a real file object', ->
    fileName = 'mocha.opts'
    vPath = fs.path.join __dirname, fileName
    result = File cwd: __dirname, path: fileName
    stat = result.stat
    result.isValid().should.be.true
    result.isDirectory().should.be.false
    result.should.have.property 'path', vPath
    result.should.have.ownProperty 'history'
    result.history.should.be.deep.equal [vPath]
    result.should.be.instanceof File.File

  it 'should create a real folder object', ->
    fileName = '.'
    vPath = fs.path.resolve __dirname, fileName
    result = File cwd: __dirname, path: fileName
    stat = result.stat
    result.isValid().should.be.true
    result.isDirectory().should.be.true
    result.should.have.property 'path', vPath
    result.should.have.ownProperty 'history'
    result.history.should.be.deep.equal [vPath]
    result.should.be.instanceof File.Folder
