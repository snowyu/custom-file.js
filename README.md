## custom-file [![npm](https://img.shields.io/npm/v/custom-file.svg)](https://npmjs.org/package/custom-file)

[![Build Status](https://img.shields.io/travis/snowyu/custom-file.js/master.svg)](http://travis-ci.org/snowyu/custom-file.js)
[![Code Climate](https://codeclimate.com/github/snowyu/custom-file.js/badges/gpa.svg)](https://codeclimate.com/github/snowyu/custom-file.js)
[![Test Coverage](https://codeclimate.com/github/snowyu/custom-file.js/badges/coverage.svg)](https://codeclimate.com/github/snowyu/custom-file.js/coverage)
[![downloads](https://img.shields.io/npm/dm/custom-file.svg)](https://npmjs.org/package/custom-file)
[![license](https://img.shields.io/npm/l/custom-file.svg)](https://npmjs.org/package/custom-file)

the custom-file can be used on any virtual file system with stream supports.


## Usage

you must call `setFileSystem()` the `fs` to CustomFile Before use it:

```coffee
through2    = require 'through2'
Stream      = require('stream').Stream
fs          = require 'graceful-fs' #or require 'fs'
CustomFile  = require 'custom-file'

fs.cwd      = process.cwd    # what's the get current working directory function.
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

file = CustomFile './readme.md' # the CustomFile can create the file or folder object base on the file path
file.should.be.instanceof File
file = CustomFile './'          # Or use the AdvanceFile with same object.
file.should.be.instanceof Folder

AdvanceFile = require 'custom-file/lib/advance'
file = AdvanceFile './readme.md'
file.should.be.instanceof AdvanceFile
file = AdvanceFile './'
file.should.be.instanceof AdvanceFile

file.loadSync read:true # here can load manually.
file.load read:true, (err, content)->
  console.log content
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

file = CustomFile('./readme.md'); // create a file object.
file.should.be.instanceof(File)
file = CustomFile('./'); // create a folder object.
file.should.be.instanceof(Folder)

var AdvanceFile = require('custom-file/lib/advance')
file = AdvanceFile('./readme.md')
file.should.be.instanceof(AdvanceFile)
file = AdvanceFile('./')
file.should.be.instanceof(AdvanceFile)

file.loadSync({read: true});
file.load({read: true}, function(err, content) {
  console.log(content);
});
```

## API


See the [abstract-file](https://github.com/snowyu/abstract-file.js).


## TODOs

+ LRUCache-able supports(not yet)
+ abstract file information class
+ abstract file operation ability
  + abstract save supports: I have no idea about this.
    I need more thinking. how to pass it to stream?
  * rename
  * create
  * append
  * delete

## License

MIT
