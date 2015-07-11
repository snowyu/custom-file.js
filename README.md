## abstract-file [![npm](https://img.shields.io/npm/v/abstract-file.svg)](https://npmjs.org/package/abstract-file)

[![Build Status](https://img.shields.io/travis/snowyu/abstract-file.js/master.svg)](http://travis-ci.org/snowyu/abstract-file.js)
[![downloads](https://img.shields.io/npm/dm/abstract-file.svg)](https://npmjs.org/package/abstract-file)
[![license](https://img.shields.io/npm/l/abstract-file.svg)](https://npmjs.org/package/abstract-file)

The abstract file information classes include AbstractFile and AbstractFolder.

+ LRUCache-able supports
+ abstract load supports
  * load stat
  * load contents
+ abstract save supports

The AbstractFile properties:

* `cwd` *(File)*: the current working directory. 
  * it's the `"root"` if `cwd` is null.
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

## Usage


## API


## License

MIT
