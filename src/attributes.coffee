path            = require 'path.js'
isObject        = require 'util-ex/lib/is/type/object'
isArray         = require 'util-ex/lib/is/type/array'
isBuffer        = require 'util-ex/lib/is/type/buffer'
cloneObject     = require 'util-ex/lib/clone-object'
stream          = require 'stream'
Stream          = stream.Stream
PassThrough     = stream.PassThrough

PATH_SEP        = path.sep

module.exports =
  cwd:
    value: ''
    type: 'String'
  base:
    value: ''
    type: 'String'
    assign: (value)->path.resolve @cwd, value
  path:
    get: ->
      if @_pathArray.length
        PATH_SEP + @_pathArray.join(PATH_SEP)
      else
        ''
    set: (value)->
      if value and isArray(value._pathArray)
        @_pathArray = value._pathArray.slice()
      else if isArray(value)
        @_pathArray = value.slice()
      else if isString(value)
        t = path.resolveArray(@cwd, @base, value)
        t = t.slice(1) if t[0] is PATH_SEP
        @_pathArray = t
      len = @history.length
      if len
        --len
        p = @path
        @history.push p if p isnt @history[len]
        
  pathArray:
    exported: false
    assigned: false
    type:'Array'
    get: -> @_pathArray
    set: (value)->@_pathArray = value.slice() if isArray value
  _pathArray:
    value: []
    enumerable: false
    type: 'Array'
  history:
    value: []
    type: 'Array'
    exported: false
    assign: (value)-> if isArray(value) then value.slice() else []
  stat: null
  contents:
    assign: (value, dest, src, name)->
      if value instanceof Stream
        t = value.pipe(new PassThrough())
        src.contents = value.pipe(new PassThrough())
        value = t
      value
  relative:
    assigned: false
    exported: false
    enumerable: false
    get: -> path.relative @base, @path
  dirname:
    assigned: false
    exported: false
    enumerable: false
    get: ->
      if len = @_pathArray.length
        PATH_SEP + @_pathArray.slice(0, len-1).join(PATH_SEP)
      else
        ''
  basename:
    assigned: false
    exported: false
    enumerable: false
    get: ->
      if len = @_pathArray.length
        @_pathArray[len-1]
      else
        ''
