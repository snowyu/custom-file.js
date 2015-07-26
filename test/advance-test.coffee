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

