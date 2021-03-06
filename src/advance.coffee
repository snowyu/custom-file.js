inherits        = require 'inherits-ex/lib/inherits'
createObject    = require 'inherits-ex/lib/createObject'
ReadDirStream   = require 'read-dir-stream'
Promise         = require 'bluebird'
AbstractFolder  = require './abstract-folder'

module.exports = class AdvanceFile
  inherits AdvanceFile, AbstractFolder

  constructor: (aPath, aOptions, done)->
    return new AdvanceFile(aPath, aOptions, done) unless @ instanceof AdvanceFile
    super

  @defineProperties: AbstractFolder.defineProperties

  _validate: (file)-> file.hasOwnProperty('stat') and file.stat?

  inspect: ->
    name = 'File'
    if @_validate(@)
      name = 'Folder' if @isDirectory()
    else
      name += '?'
    '<'+ name + ' ' + @_inspect() + '>'

  _getStreamSync: (aFile)->
    stat = aFile.stat
    stat = aFile.stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirStreamSync(aFile)
    else
      super aFile

  _getStream: (aFile, cb)->
    stat = aFile.stat
    stat = aFile.stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirStream aFile, cb
    else
      super aFile, cb

  _getBufferSync: (aFile)-> # return the array of files
    stat = aFile.stat
    stat = aFile.stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirBufferSync aFile
    else
      super aFile

  _getBuffer: (aFile, cb)-> # return the array of files
    stat = aFile.stat
    stat = aFile.stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirBuffer aFile, cb
    else
      super aFile, cb
