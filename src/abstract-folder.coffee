isFunction      = require 'util-ex/lib/is/type/function'
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
  @defineProperties AbstractFolder,
    filter:
      type: 'Function'
  , false

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

  _createFileObject: (aClass, aOptions, aFilter)->
    aOptions.cwd = @cwd # for ReadDirStream
    aOptions.base = @base
    aFilter ?= @filter
    if not isFunction(aFilter) or aFilter.call(@, aOptions)
      result = createObject aClass, aOptions
    result

  createFileObject: (options, aFilter)->
    @_createFileObject @Class || @constructor, options, aFilter

  _getDirStreamSync: (aFile)->
    ReadDirStream aFile.path, makeObjFn: (f)=>@createFileObject.call(@, f, aFile.filter)

  _getDirStream: (aFile, cb)->
    result = ReadDirStream aFile.path, makeObjFn: (f)=>
      @createFileObject.call(@, f, aFile.filter)
    cb(null, result)

  _getDirBufferSync: (aFile)-> # return the array of files
    vPath = aFile.path
    dirs = fs.readdirSync vPath
    result = []
    for file in dirs
    #dirs = dirs.map (file)=>
      stat = fs.statSync path.join vPath, file
      file = @createFileObject path:path.join(vPath, file), stat:stat, aFile.filter
      result.push file if file
    result

  _getDirBuffer: (aFile, cb)-> # return the array of files
    vPath = aFile.path
    that  = @
    fs.readdir vPath
    .map (file)->
      fs.stat path.join(vPath, file)
      .then (stat)-> that.createFileObject
        path:path.join(vPath, file)
        stat:stat
        , aFile.filter
    , concurrency: 10
    .then (files)->
      files.filter Boolean
    .nodeify(cb)
