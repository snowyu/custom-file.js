inherits        = require 'inherits-ex/lib/inherits'
createObject    = require 'inherits-ex/lib/createObject'
ReadDirStream   = require 'read-dir-stream'
Promise         = require 'bluebird'
AbstractFolder  = require './abstract-folder'
File            = require './file'

module.exports = class Folder
  inherits Folder, AbstractFolder

  constructor: (aPath, aOptions, done)->
    return new Folder(aPath, aOptions, done) unless @ instanceof Folder
    super

  @defineProperties: AbstractFolder.defineProperties

  _validate: (file)->
    file.hasOwnProperty('stat') and file.stat? and file.stat.isDirectory()

  createFileObject: (options, aFilter)->
    stat = options.stat
    vClass = if stat and stat.isDirectory() then Folder else File
    @_createFileObject vClass, options, aFilter

  _getStreamSync: (aFile)->
    @_getDirStreamSync(aFile)
  _getStream: (aFile, cb)->
    @_getDirStream aFile, cb
  _getBufferSync: (aFile)-> # return the array of files
    @_getDirBufferSync aFile
  _getBuffer: (aFile, cb)-> # return the array of files
    @_getDirBuffer aFile, cb
