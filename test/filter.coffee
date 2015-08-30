chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
extend          = require 'util-ex/lib/_extend'
path            = fs.path

module.exports = (Folder, aOptions, filterFn, expected)->
  ->
    aOptions ?= path:path.join(__dirname, 'fixtures', 'folder'), base: __dirname
    filterFn ?= (file)->path.extname(file.path) is '.md'
    expected ?= ['fixtures/folder/index.md']
    it 'should filter files sync default', ->
      dir = Folder extend {filter: filterFn}, aOptions
      result = dir.loadSync read:true
      result = result.map (file)->file.relative
      expect(result).be.deep.equal expected
    it 'should filter files sync buffer', ->
      dir = Folder aOptions
      result = dir.loadSync read:true, filter: filterFn
      result = result.map (file)->file.relative
      expect(result).be.deep.equal expected
    it 'should filter files sync stream', (done)->
      dir = Folder aOptions
      result = []
      dir.loadSync read:true, buffer:false, filter: filterFn
      .on 'data', (file)->
        result.push file.relative
      .on 'error', (err)->done(err)
      .on 'end', ->
        expect(result).be.deep.equal expected
        done()

    it 'should filter files async default', (done)->
      dir = Folder extend {filter: filterFn}, aOptions
      dir.load read:true, (err, result)->
        unless err
          result = result.map (file)->file.relative
          expect(result).be.deep.equal expected
        done(err)
    it 'should filter files async buffer', (done)->
      dir = Folder aOptions
      dir.load read:true, filter: filterFn, (err, result)->
        unless err
          result = result.map (file)->file.relative
          expect(result).be.deep.equal expected
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
          done()
