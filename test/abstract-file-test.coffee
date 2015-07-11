chai            = require 'chai'
sinon           = require 'sinon'
sinonChai       = require 'sinon-chai'
should          = chai.should()
expect          = chai.expect
assert          = chai.assert
chai.use(sinonChai)

fs              = require 'fs'
path            = require 'path.js'
inherits        = require 'inherits-ex/lib/inherits'
extend          = require 'util-ex/lib/_extend'
setImmediate    = setImmediate || process.nextTick

describe 'AbstractFile', ->
