AbstractFile    = require './abstract-file'
File            = require './file'
Folder          = require './folder'
module.exports  = customFile =
  setFileSystem: (value)->
    AbstractFile.fs = value
    customFile
  File: File
  Folder: Folder