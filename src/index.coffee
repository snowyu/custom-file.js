propertyManager = require 'property-manager/ability'
path            = require 'path.js'
isObject        = require 'util-ex/lib/is/type/object'
isArray         = require 'util-ex/lib/is/type/array'
isBuffer        = require 'util-ex/lib/is/type/buffer'
cloneObject     = require 'util-ex/lib/clone-object'
stream          = require 'stream'
attributes      = require './attributes'
Stream          = stream.Stream
PassThrough     = stream.PassThrough

PATH_SEP        = path.sep

module.exports = class AbstractFile
  propertyManager AbstractFile, name:'advance', nonExported1stChar:'_'

  AbstractFile.defineProperties AbstractFile, attributes

  constructor: (aPath, aOptions)->
    if isObject aPath
      aOptions = aPath
      aPath = undefined
    aOptions?={}
    aOptions.path = aPath if aPath
    @initialize aOptions