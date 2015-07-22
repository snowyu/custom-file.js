inherits        = require 'inherits-ex/lib/inherits'
createObject    = require 'inherits-ex/lib/createObject'
ReadDirStream   = require 'read-dir-stream'
Promise         = require 'bluebird'
AbstractFile    = require 'abstract-file'
File            = require './file'

module.exports = class Folder
  fs = null
  path = null

  inherits Folder, File

  constructor: (aPath, aOptions, done)->
    return new Folder(aPath, aOptions, done) unless @ instanceof Folder
    @_updateFS()
    super

  _updateFS: ->
    unless fs
      fs = AbstractFile.fs
      throw new TypeError('no file system specified') unless fs
      path = fs.path
      fs.stat      = Promise.promisify fs.stat, fs
      fs.readdir   = Promise.promisify fs.readdir, fs
      ReadDirStream::_stat = fs.stat
      ReadDirStream::_readdir = fs.readdir

  _validate: (file)->
    file.stat? and file.stat.isDirectory()

  createFileObj: (options)->
    stat = options.stat
    options.cwd = @cwd # for ReadDirStream
    options.base = @base
    vClass = if stat and stat.isDirectory() then Folder else File
    createObject vClass, options

  _getStreamSync: (aFile)->
    ReadDirStream aFile.path, makeObjFn: =>@createFileObj.apply(@, arguments)
  _getStream: (aFile, cb)->
    result = ReadDirStream aFile.path, makeObjFn: =>
      @createFileObj.apply(@, arguments)
    cb(null, result)
  _getBufferSync: (aFile)-> # return the array of files
    vPath = aFile.path
    dirs = fs.readdirSync vPath
    dirs = dirs.map (file)=>
      stat = fs.statSync path.join vPath, file
      @createFileObj path:path.join(vPath, file), stat:stat
  _getBuffer: (aFile, cb)-> # return the array of files
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
