inherits        = require 'inherits-ex/lib/inherits'
createObject    = require 'inherits-ex/lib/createObject'
ReadDirStream   = require 'read-dir-stream'
Promise         = require 'bluebird'
AbstractFile    = require 'abstract-file'
File            = require './file'

module.exports = class AbstractFolder
  fs = null
  path = null

  inherits AbstractFolder, File

  @defineProperties: File.defineProperties

  constructor: (aPath, aOptions, done)->
    return new AbstractFolder(aPath, aOptions, done) unless @ instanceof AbstractFolder
    super

  _updateFS: (aFS)->
    unless fs and AbstractFile.fs
      aFS = AbstractFile.fs unless aFS
      fs = aFS
      fs.stat      = Promise.promisify fs.stat, fs
      fs.readdir   = Promise.promisify fs.readdir, fs
      ReadDirStream::_stat = fs.stat
      ReadDirStream::_readdir = fs.readdir
    super aFS
    path = fs.path unless path

  _createFileObject: (aClass, aOptions)->
    aOptions.cwd = @cwd # for ReadDirStream
    aOptions.base = @base
    createObject aClass, aOptions

  createFileObject: (options)->
    @_createFileObject @Class || @constructor, options

  _getDirStreamSync: (aFile)->
    ReadDirStream aFile.path, makeObjFn: =>@createFileObject.apply(@, arguments)

  _getDirStream: (aFile, cb)->
    result = ReadDirStream aFile.path, makeObjFn: =>
      @createFileObject.apply(@, arguments)
    cb(null, result)

  _getDirBufferSync: (aFile)-> # return the array of files
    vPath = aFile.path
    dirs = fs.readdirSync vPath
    dirs = dirs.map (file)=>
      stat = fs.statSync path.join vPath, file
      @createFileObject path:path.join(vPath, file), stat:stat

  _getDirBuffer: (aFile, cb)-> # return the array of files
    vPath = aFile.path
    makeObj = =>@createFileObject.apply(@, arguments)
    fs.readdir vPath
    .map (file)->
      fs.stat path.join(vPath, file)
      .then (stat)-> makeObj
        path:path.join(vPath, file)
        stat:stat
    , concurrency: 10
    .nodeify(cb)
