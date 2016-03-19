chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

isFunction      = require 'util-ex/lib/is/type/function'
setImmediate    = setImmediate || process.nextTick


fs              = require 'fs'
fs.path         = require('path.js')
AbstractFile    = require 'abstract-file'
File            = require '../src/file'

fileBehaviorTest= require 'abstract-file/test'
loadContentTest = fileBehaviorTest.loadFileContent


describe 'File Class', ->
  beforeEach ->
    @File = File
    @canLoadStatAsync = true
    @cwd = __dirname
    @contentPath = fs.path.join 'fixtures', 'folder', 'index.md'
    @loadContentTest = loadContentTest
    @content = '''
    ---
    title: 'testTitle'
    ---
    hi, it's a test

    '''


  fileBehaviorTest(fs)
