## custom-file [![npm](https://img.shields.io/npm/v/custom-file.svg)](https://npmjs.org/package/custom-file)

[![Build Status](https://img.shields.io/travis/snowyu/custom-file.js/master.svg)](http://travis-ci.org/snowyu/custom-file.js)
[![downloads](https://img.shields.io/npm/dm/custom-file.svg)](https://npmjs.org/package/custom-file)
[![license](https://img.shields.io/npm/l/custom-file.svg)](https://npmjs.org/package/custom-file)

It abstracts the File and Folder classes, can be used on any virtual file system, and stream supports.

+ LRUCache-able supports(not yet)
+ abstract file information class
+ abstract file operation ability
  + abstract load supports
    * load stat
    * load content
  + abstract save supports: I have no idea about this.
    I need more thinking. how to pass it to stream?
  * rename
  * create
  * append
  * delete

## Usage

you must set the `fs`(file system) to AbstractFile Before use it:

```coffee
through2    = require 'through2'
Stream      = require('stream').Stream
fs          = require 'graceful-fs' #or require 'fs'
CustomFile  = require 'custom-file'

fs.cwd      = process.cwd    # what's the current working directory.
CustomFile.setFileSystem(fs) # and should set your filesystem first.

File = CustomFile.File
Folder = CustomFile.Folder

file = File './readme.md', load:true, read:true, buffer:true
console.log file.contents #<Buffer 23...>
file = File './readme.md', load:true, read:true
console.log file.contents instanceof Stream #true
file.pipe process.stdout, end:false #pipe to stdout(the stdout should be never closed.)

file = Folder './', load:true, read:true, buffer:true
console.log file.contents #[<File "README.md">, <Folder "src">,...]
file = Folder './', load:true, read:true
console.log file.contents instanceof Stream #true
file.pipe through2.obj (aFile, enc, next)->next null, aFile.inspect()+'\n'
.pipe process.stdout, end:false
```

the following is javascript:

```js
var through2 = require('through2');
var Stream = require('stream').Stream;
var fs = require('graceful-fs');
var CustomFile = require('custom-file');

fs.cwd = process.cwd;
CustomFile.setFileSystem(fs);

var File = CustomFile.File;

var Folder = CustomFile.Folder;

var file = File('./readme.md', {
  load: true,
  read: true,
  buffer: true
});

console.log(file.contents);

file = File('./readme.md', {
  load: true,
  read: true
});

console.log(file.contents instanceof Stream);

file.pipe(process.stdout, {
  end: false
});

file = Folder('./', {
  load: true,
  read: true,
  buffer: true
});

console.log(file.contents);

file = Folder('./', {
  load: true,
  read: true
});

console.log(file.contents instanceof Stream);

file.pipe(through2.obj(function(aFile, enc, next) {
  return next(null, aFile.inspect() + '\n');
})).pipe(process.stdout, {
  end: false
});
```

* fs methods(used):
  * cwd(): return the current work directory
  * stat(path, callback): Asynchronous stat.
  * statSync(path): Synchronous stat.
  * readdir(path, callback): Asynchronous readdir
  * readdirSync(path): Synchronous readdir
  * createReadStream(path[, options]):Returns a new ReadStream object
  * readFile(filename[, options], callback):Asynchronously reads the entire contents of a file
  * readFileSync(path): Synchronous version of readFile. Returns the contents of the filename.

The FileInfo properties:

* `cwd` *(String)*: the current working directory.
  * it's the `"root"` if `cwd` is ''.
* `path` *(String)*: the file path. it will be stored as absolute path always.
  * `path` = path.resolve(`cwd`, `path`)
  * internal stored as an array of path.
  * change path means rename it.
* `name` *(String)*: the name of the file. = `basename`
* `base` *(String)*: the file base path. it is absolute path always.
  * the `cwd` will be the file base path if empty
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
  * toString(): return the full path.

## API


## License

MIT
