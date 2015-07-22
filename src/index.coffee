replaceCtor     = require 'inherits-ex/lib/replaceCtor'
isFunction      = require 'util-ex/lib/is/type/function'
isObject        = require 'util-ex/lib/is/type/object'
extend          = require 'util-ex/lib/_extend'

AbstractFile    = require 'abstract-file'
File            = require './file'
Folder          = require './folder'

module.exports  = class CustomFile
  constructor: (aPath, aOptions, done)->
    throw new TypeError('no file system specified') unless AbstractFile.fs
    if isObject aPath
      done = aOptions if aOptions
      aOptions = aPath
      aPath = aOptions.path
    aOptions?={}
    vOpts = extend {}, aOptions
    vOpts.load = true
    vOpts.validate = false
    vOpts.read = false

    result = File aPath, vOpts
    if result.isDirectory()
      replaceCtor result, Folder
      result._updateFS()

    if aOptions.load
      if isFunction(done)
        result.load(aOptions, done)
      else
        result.loadSync(aOptions)

    return result

  @setFileSystem: (value)->
    AbstractFile.fs = value
    CustomFile
  @File: File
  @Folder: Folder