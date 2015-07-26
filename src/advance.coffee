inherits        = require 'inherits-ex/lib/inherits'
createObject    = require 'inherits-ex/lib/createObject'
ReadDirStream   = require 'read-dir-stream'
Promise         = require 'bluebird'
AbstractFile    = require 'abstract-file'
File            = require './file'

module.exports = class AdvanceFile
  fs = null
  path = null

  inherits AdvanceFile, File

  constructor: (aPath, aOptions, done)->
    return new AdvanceFile(aPath, aOptions, done) unless @ instanceof AdvanceFile
    vFS = aOptions.fs if aOptions
    super

  _updateFS: (aFS)->
    unless fs
      AbstractFile.fs = aFS unless AbstractFile.fs
      fs = AbstractFile.fs
      path = fs.path
      fs.stat      = Promise.promisify fs.stat, fs
      fs.readdir   = Promise.promisify fs.readdir, fs
      ReadDirStream::_stat = fs.stat
      ReadDirStream::_readdir = fs.readdir
    super aFS

  _validate: (file)->file.stat?
  inspect: ->
    name = 'File'
    if @stat
      name = 'Folder' if @stat.isDirectory()
    else
      name += '?'
    '<'+ name + ' ' + @_inspect() + '>'

  createFileObj: (options)->
    stat = options.stat
    options.cwd = @cwd # for ReadDirStream
    options.base = @base
    createObject AbstractFile, options

  _getDirStreamSync: (aFile)->
      ReadDirStream aFile.path, makeObjFn: =>@createFileObj.apply(@, arguments)
  _getDirStream: (aFile, cb)->
    result = ReadDirStream aFile.path, makeObjFn: =>
      @createFileObj.apply(@, arguments)
    cb(null, result)
  _getDirBufferSync: (aFile)-> # return the array of files
    vPath = aFile.path
    dirs = fs.readdirSync vPath
    dirs = dirs.map (file)=>
      stat = fs.statSync path.join vPath, file
      @createFileObj path:path.join(vPath, file), stat:stat
  _getDirBuffer: (aFile, cb)-> # return the array of files
    vPath = aFile.path
    makeObj = =>@createFileObj.apply(@, arguments)
    fs.readdir vPath
    .map (file)->
      fs.stat path.join(vPath, file)
      .then (stat)-> makeObj
        path:path.join(vPath, file)
        stat:stat
    , concurrency: 10
    .nodeify(cb)

  _getStreamSync: (aFile)->
    stat = aFile.stat
    stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirStreamSync(aFile)
    else
      super aFile
  _getStream: (aFile, cb)->
    stat = aFile.stat
    stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirStream aFile, cb
    else
      super aFile, cb
  _getBufferSync: (aFile)-> # return the array of files
    stat = aFile.stat
    stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirBufferSync aFile
    else
      super aFile
  _getBuffer: (aFile, cb)-> # return the array of files
    stat = aFile.stat
    stat = @_loadStatSync(aFile) unless stat
    if stat.isDirectory()
      @_getDirBuffer aFile, cb
    else
      super aFile, cb
