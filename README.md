## abstract-file [![npm](https://img.shields.io/npm/v/abstract-file.svg)](https://npmjs.org/package/abstract-file)

[![Build Status](https://img.shields.io/travis/snowyu/abstract-file.js/master.svg)](http://travis-ci.org/snowyu/abstract-file.js)
[![downloads](https://img.shields.io/npm/dm/abstract-file.svg)](https://npmjs.org/package/abstract-file)
[![license](https://img.shields.io/npm/l/abstract-file.svg)](https://npmjs.org/package/abstract-file)

The abstract file classes include AbstractFile and AbstractFolder.

+ LRUCache-able supports
+ abstract file information class
+ abstract file operation ability
  + abstract load supports
    * load stat
    * load contents
  + abstract save supports
  * rename
  * create
  * append
  * delete

The FileInfo properties:

* `cwd` *(String)*: the current working directory. 
  * it's the `"root"` if `cwd` is ''.
* `path` *(String)*: the file path. it will be stored as absolute path always.
  * `path` = path.resolve(`cwd`, `path`)
  * internal stored as an array of path.
  * change path means rename it.
* `name` *(String)*: the name of the file. = `basename`
  * readonly
* !`parent` *(File)*: the parent of this file path. 
  * I can use the dirname to determine the `parent`.
* !`base` *(String)*: the file base path. should I need this?
  * !the `cwd` will be the file base path if empty
* `history` *(Array)*: the history of this file path changes.
* `contents` *(Buffer|Array|Stream)*: the contents of this file.
* `stat` *(Stats)*: the stats of this file.
  * `isDirectory()` should be exists.
* computed properties:
  * `dirname` *(String)*: the dirname of this file.
  * `basename` *(String)*: the basename of this file.
  * `extname` *(String)*: the extname of this file.
  * `relative` *(String)*: the relative path of this file.
    * path.relative(path.resovle(cwd, base), path.resolve(cwd, base, path))
    * path.relative(`base`, `path`) if `base` is absolute path
    * path.relative(`cwd`, `path`) if no `base` property

* methods:
  * resolve(paths...): path.resolve @cwd, paths...
  * toString(): return the full path.

## Usage


## API


## License

MIT
