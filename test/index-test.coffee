chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

Stream          = require('stream').Stream
fs              = require 'fs'
fs.cwd          = process.cwd
inherits        = require 'inherits-ex/lib/inherits'
extend          = require 'util-ex/lib/_extend'
File            = require '../src'

setImmediate    = setImmediate || process.nextTick
File.setFileSystem fs

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

  it 'should create a real file object and load contents', ->
    fileName = 'mocha.opts'
    vPath = fs.path.join __dirname, fileName
    result = File cwd: __dirname, path: fileName, load:true, read:true, buffer:false
    stat = result.stat
    result.isValid().should.be.true
    result.isDirectory().should.be.false
    result.should.have.property 'path', vPath
    result.should.have.ownProperty 'history'
    result.history.should.be.deep.equal [vPath]
    result.should.be.instanceof File.File
    should.exist result.contents
    result.contents.should.be.instanceof Stream

  it 'should create a real file object and load contents async', (done)->
    fileName = 'mocha.opts'
    vPath = fs.path.join __dirname, fileName
    result = File cwd: __dirname,
    path: fileName, load:true, read:true, buffer:false, (err, contents)->
      unless err
        should.exist contents
        contents.should.be.instanceof Stream
      done(err, contents)
