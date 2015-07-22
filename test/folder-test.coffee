chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
AbstractFile    = require 'abstract-file'
Folder          = require '../src/folder'
path            = fs.path

fileBehaviorTest = require 'abstract-file/test'
loadContentTest = fileBehaviorTest.loadFolderContent

describe 'Folder Class', ->
  beforeEach ->
    @File = Folder
    @cwd = __dirname
    @canLoadStatAsync = true
    @contentPath = 'fixtures/folder/'
    @loadContentTest = loadContentTest
    @content = [
      'fixtures/folder/.ignore'
      'fixtures/folder/index.md'
      'fixtures/folder/my.cofffee'
      'fixtures/folder/subfolder1'
      'fixtures/folder/subfolder2'
    ]

  fileBehaviorTest()

  it 'should create a folder object via constructor function directly', ->
    dir = Folder(path.join __dirname, 'fixtures', 'folder')
    cfg = read:true
    #dir.loadSync(cfg)
    #console.log JSON.stringify(dir,null,1)
