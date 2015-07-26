chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
AbstractFile    = require 'abstract-file'
File            = require '../src/advance'
path            = fs.path

fileBehaviorTest = require 'abstract-file/test'

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


  fileBehaviorTest()

describe 'AdvanceFile Class Folder test', ->
  beforeEach ->
    @File = File
    @cwd = __dirname
    @canLoadStatAsync = true
    @contentPath = 'fixtures/folder/'
    @loadContentTest = fileBehaviorTest.loadFolderContent
    @content = [
      'fixtures/folder/.ignore'
      'fixtures/folder/index.md'
      'fixtures/folder/my.cofffee'
      'fixtures/folder/subfolder1'
      'fixtures/folder/subfolder2'
    ]

  fileBehaviorTest()

  it 'should update fs on new object', ->
    AbstractFile.fs = null
    File './README.md', fs: fs
    should.exist AbstractFile.fs
    AbstractFile.fs.should.be.equal fs

describe 'AdvanceFile#inspect()', ->
  it 'should show "<File?>" if no file stat', ->
    result = File './README.md'
    result.inspect().should.be.equal '<File? "README.md">'
  it 'should show "<File>" if it\'s a file', ->
    result = File './README.md', load:true
    result.inspect().should.be.equal '<File "README.md">'
  it 'should show "<Folder>" if it\'s a direcory', ->
    result = File './', load:true
    result.inspect().should.be.equal '<Folder ".">'
