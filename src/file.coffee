inherits        = require 'inherits-ex/lib/inherits'
stripBom        = require 'strip-bom'
stripBomStream  = require 'strip-bom-stream'
AbstractFile    = require 'abstract-file'

module.exports  = class File
  fs = AbstractFile.fs

  inherits File, AbstractFile

  constructor: (aPath, aOptions, done)->
    return new File(aPath, aOptions, done) unless @ instanceof File
    vFS = aOptions.fs if aOptions
    @_updateFS(vFS)
    super

  _updateFS: (aFS)->
    unless fs and AbstractFile.fs
      AbstractFile.fs = aFS
      fs = AbstractFile.fs
      ### !pragma coverage-skip-next ###
      throw new TypeError('no file system specified') unless fs

  _validate: (file)->
    file.stat? and not file.stat.isDirectory()

  _loadStat: (aOptions, done)->
    fs.stat aOptions.path, (err, result)=>
      @stat = result unless err
      done(err, result)
      return
    @

  _loadStatSync: (aOptions)->
    fs.statSync(aOptions.path)

  _loadContent: (aOptions, done)->
    if aOptions.buffer != false
      @_getBuffer(aOptions, done)
    else
      @_getStream(aOptions, done)

  _loadContentSync: (aOptions)->
    if aOptions.buffer != false
      @_getBufferSync(aOptions)
    else
      @_getStreamSync(aOptions)

  _getStreamSync: (file)->
    fs.createReadStream(file.path, file).pipe(stripBomStream())
  _getBufferSync: (file)->
    data = fs.readFileSync file.path, file
    data = stripBom(data)
    #data = data.slice(file.skipSize) if isNumber file.skipSize
  _getStream: (file, done)->
    result = fs.createReadStream(file.path, file).pipe(stripBomStream())
    done null, result
    @
  _getBuffer: (file, done)->
    fs.readFile file.path, file, (err, data) ->
      unless err
        data = stripBom(data)
        #data = data.slice(file.skipSize) if isNumber file.skipSize
      done err, data
