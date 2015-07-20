propertyManager = require 'property-manager/ability'
path            = require 'path.js/lib/path'
isObject        = require 'util-ex/lib/is/type/object'
isFunction      = require 'util-ex/lib/is/type/function'
isBoolean       = require 'util-ex/lib/is/type/boolean'
isArray         = require 'util-ex/lib/is/type/array'
isBuffer        = require 'util-ex/lib/is/type/buffer'
cloneObject     = require 'util-ex/lib/clone-object'
defineProperty  = require 'util-ex/lib/defineProperty'
stream          = require 'stream'
attributes      = require './attributes'
Stream          = stream.Stream
PassThrough     = stream.PassThrough
streamify       = require 'stream-array'
setImmediate    = setImmediate || process.nextTick

PATH_SEP        = path.sep

module.exports = class AbstractFile
  gfs = null

  propertyManager AbstractFile, name:'advance', nonExported1stChar:'_'

  AbstractFile.defineProperties AbstractFile, attributes

  setFS = (value)->
    gfs = value
    path.cwd = value.cwd if value and isFunction value.cwd
    return

  defineProperty @, 'fs', undefined,
    get: -> gfs
    set: setFS

  defineProperty @::, 'fs', undefined,
    get: -> gfs
    set: setFS

  constructor: (aPath, aOptions)->
    if isObject aPath
      aOptions = aPath
      aPath = undefined
    aOptions?={}
    aOptions.path = aPath if aPath
    @initialize aOptions

  isStream: -> @contents instanceof Stream
  isBuffer: -> isBuffer @contents
  isDirectory: -> @stat? and isFunction(@stat.isDirectory) and @stat.isDirectory()
  toString: -> @path
  fullPath: (aOptions)->
    cwd = aOptions.cwd || ''
    base = aOptions.cwd || ''
    vPath = aOptions.path || ''
    path.resovle cwd, base, vPath

  load: (aOptions, done)->
    if isFunction aOptions
      done = aOptions
      aOptions = null
    aOptions = @mergeTo(aOptions)
    unless @stat?
      @_loadStat aOptions, (err, stat)=>
        @stat = stat
        if !err
          try @validate() catch err
        return done(err) if err
        if aOptions.read and stat? and !@contents?
          @_loadContent aOptions, (err, result)=>
            @contents = result unless err
            done err, result
        else
          done(null, @contents)
        return
    else if aOptions.read and !@contents?
      @loadContent(aOptions, done)
    else
      done(null, @contents)
    @
  loadSync: (aOptions)->
    if isFunction(@_loadStatSync)
      aOptions = @mergeTo(aOptions)
      @stat = @_loadStatSync(aOptions) unless @stat?
      @validate()
      if aOptions.read and @stat? and !@contents?
        if isFunction(@_loadContentSync)
          @contents = @_loadContentSync(aOptions)
        else
          throw new TypeError '_loadContentSync not implemented'
      else
        @contents
    else
      throw new TypeError '_loadStatSync not implemented'

  _loadStat: (aOptions, done)->
    if @_loadStatSync
      setImmediate =>
        try
          stat = @_loadStatSync(aOptions)
          done(null, stat)
        catch e
          done(e)
        return
    else
      done(new TypeError '_loadStat Async not implemented')
    @

  _loadContent: (aOptions, done)->
    if @_loadContentSync
      setImmediate =>
        try
          result = @_loadContentSync(aOptions)
          done(null, result)
        catch e
          done(e)
        return
    else
      done(new TypeError '_loadContent Async not implemented')
    @

  loadStat: (aOptions, done)->
    if isFunction aOptions
      done = aOptions
      aOptions = null
    aOptions = @mergeTo(aOptions)
    _loadStat aOptions, done
    @
  loadStatSync: (aOptions)->
    aOptions = @mergeTo(aOptions)
    if @_loadStatSync
      result = @_loadStatSync aOptions
    else
      throw new TypeError '_loadStatSync not implemented'
    result

  loadContents: (aOptions, done)->
    if isFunction aOptions
      done = aOptions
      aOptions = null
    aOptions = @mergeTo(aOptions)
    @_loadContent aOptions, done
    @
  loadContentsSync: ->
    if isFunction(@_loadContentSync)
      aOptions = @mergeTo aOptions
      result = @_loadContentSync aOptions
    else
      throw new TypeError 'loadContentSync not implemented'
    result

  _validate: (aOptions)->
    aOptions.stat?
  validate: (aOptions, raiseError)->
    if isBoolean aOptions
      raiseError = aOptions
      aOptions = null
    aOptions = @mergeTo(aOptions)
    result = @_validate aOptions
    if raiseError and not result
      throw new TypeError @name+': invalid path '+aOptions.path
    result
  isValid: (aOptions)->
    @Validate(aOptions, false)

  pipe: (aStream, options)->
    options?= {}
    options.end = true unless options.end?

    if @isStream()
      return @contents.pipe(aStream, options)

    if @isBuffer()
      if options.end
        aStream.end(@contents)
      else
        aStream.write(@contents)
      return aStream

    if isArray @contents
      return streamify(@contents).pipe(aStream, options)

    # isNull
    if options.end
      aStream.end()

    return aStream

  _loadStatSync: (aOptions)->
    gfs.statSync(@fullPath(aOptions))
