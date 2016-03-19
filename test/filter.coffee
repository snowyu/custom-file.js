chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
extend          = require 'util-ex/lib/_extend'
fs.path         = require('path.js')
path            = fs.path

module.exports = (Folder, aOptions, filterFn, expected)->
  ->
    aOptions ?= path:path.join(__dirname, 'fixtures', 'folder'), base: __dirname
    filterFn ?= (file)->path.extname(file.path) is '.md'
    expected ?= [path.join('fixtures', 'folder', 'index.md')]
    filterFn = sinon.spy filterFn
    beforeEach ->filterFn.reset()
    expectFilterFnCalledOn = (aThis)->
      expect(filterFn.thisValues).have.length.at.least 1
      for v in filterFn.thisValues
        expect(v).be.equal aThis
    it 'should filter files sync default', ->
      dir = Folder extend {filter: filterFn}, aOptions
      result = dir.loadSync read:true
      result = result.map (file)->file.relative
      expect(result).be.deep.equal expected
      filterFn.alwaysCalledOn dir
      expectFilterFnCalledOn dir
    it 'should filter files sync buffer', ->
      dir = Folder aOptions
      result = dir.loadSync read:true, filter: filterFn
      result = result.map (file)->file.relative
      expect(result).be.deep.equal expected
      expectFilterFnCalledOn dir
    it 'should filter files sync stream', (done)->
      dir = Folder aOptions
      result = []
      dir.loadSync read:true, buffer:false, filter: filterFn
      .on 'data', (file)->
        result.push file.relative
      .on 'error', (err)->done(err)
      .on 'end', ->
        expect(result).be.deep.equal expected
        expectFilterFnCalledOn dir
        done()

    it 'should filter files async default', (done)->
      dir = Folder extend {filter: filterFn}, aOptions
      dir.load read:true, (err, result)->
        unless err
          result = result.map (file)->file.relative
          expect(result).be.deep.equal expected
          expectFilterFnCalledOn dir
        done(err)
    it 'should filter files async buffer', (done)->
      dir = Folder aOptions
      dir.load read:true, filter: filterFn, (err, result)->
        unless err
          result = result.map (file)->file.relative
          expect(result).be.deep.equal expected
          expectFilterFnCalledOn dir
        done(err)
    it 'should filter files async stream', (done)->
      dir = Folder aOptions
      result = []
      dir.load read:true, buffer:false, filter: filterFn, (err, stream)->
        return done(err) if err
        stream.on 'data', (file)->
          result.push file.relative
        .on 'error', (err)->done(err)
        .on 'end', ->
          expect(result).be.deep.equal expected
          expectFilterFnCalledOn dir
          done()
