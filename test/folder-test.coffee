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
fs.path         = require('path.js')
path            = fs.path

fileBehaviorTest = require 'abstract-file/test'
filterBehaviorTest = require './filter'
loadContentTest = fileBehaviorTest.loadFolderContent

describe 'Folder Class', ->
  beforeEach ->
    @File = Folder
    @cwd = __dirname
    @canLoadStatAsync = true
    @contentPath = path.join 'fixtures', 'folder'
    @loadContentTest = loadContentTest
    @content = [
      path.join 'fixtures', 'folder', '.ignore'
      path.join 'fixtures', 'folder', 'index.md'
      path.join 'fixtures', 'folder', 'my.cofffee'
      path.join 'fixtures', 'folder', 'subfolder1'
      path.join 'fixtures', 'folder', 'subfolder2'
    ]

  fileBehaviorTest(fs)

  it 'should create a folder object via constructor function directly', ->
    dir = Folder(path.join __dirname, 'fixtures', 'folder')
    cfg = read:true
    #dir.loadSync(cfg)
    #console.log JSON.stringify(dir,null,1)

  describe 'filter', filterBehaviorTest(Folder)
