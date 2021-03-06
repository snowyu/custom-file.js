chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
fs.path         = require('path.js')
AbstractFile    = require 'abstract-file'
File            = require '../src/advance'
path            = fs.path

fileBehaviorTest = require 'abstract-file/test'
filterBehaviorTest = require './filter'

describe 'AdvanceFile Class File test', ->
  beforeEach ->
    @File = File
    @canLoadStatAsync = true
    @cwd = __dirname
    @contentPath = 'fixtures/folder/index.md'
    @loadContentTest = fileBehaviorTest.loadFileContent
    @content = '''
    ---
    title: 'testTitle'
    ---
    hi, it's a test

    '''


  fileBehaviorTest(fs)

describe 'AdvanceFile Class Folder test', ->
  beforeEach ->
    @File = File
    @cwd = __dirname
    @canLoadStatAsync = true
    @contentPath = path.join 'fixtures', 'folder'
    @loadContentTest = fileBehaviorTest.loadFolderContent
    @content = [
      path.join 'fixtures', 'folder', '.ignore'
      path.join 'fixtures', 'folder', 'index.md'
      path.join 'fixtures', 'folder', 'my.cofffee'
      path.join 'fixtures', 'folder', 'subfolder1'
      path.join 'fixtures', 'folder', 'subfolder2'
    ]

  fileBehaviorTest(fs)

  it 'should update fs on new object', ->
    AbstractFile.fs = null
    File './README.md', fs: fs
    should.exist AbstractFile.fs
    AbstractFile.fs.should.be.equal fs

describe 'AdvanceFile#inspect()', ->
  it 'should show "<File?>" if no file stat', ->
    result = File 'README.md'
    result.inspect().should.be.equal '<File? "README.md">'
  it 'should show "<File>" if it\'s a file', ->
    result = File 'README.md', load:true
    result.inspect().should.be.equal '<File "README.md">'
  it 'should show "<Folder>" if it\'s a direcory', ->
    result = File '.', load:true
    result.inspect().should.be.equal '<Folder ".">'

describe 'filter', filterBehaviorTest(File)
