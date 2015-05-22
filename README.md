# Commander file [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Wait the stdin/file/uri by extended [commander.js](https://github.com/tj/commander.js)

## Installation
```bash
$ npm install commander-file
```

# Upgrade option parsing

my-program:
```js
#!/usr/bin/env node

var program = require('commander-file');
program
.usage('[options] [file]')
.parse(process.argv).then(function(fileData){
  console.log(fileData);
});
```

## Example

__Can read stdin/file/url to `fileData`__.

### Stdin
```bash
$ echo -n 'foo' > bar.txt
$ node my-program bar.txt
# foo
```

### File
```bash
$ echo -n 'bar' | node my-program
# bar
```

> Parsing only first argument.

### Uri
```bash
$ node my-program http://static.edgy.black/fixture.txt
# baz
```

> Parsing only first argument.

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[npm-image]:https://img.shields.io/npm/v/commander-file.svg?style=flat-square
[npm]: https://npmjs.org/package/commander-file
[travis-image]: http://img.shields.io/travis/59naga/commander-file.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/commander-file
[coveralls-image]: http://img.shields.io/coveralls/59naga/commander-file.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/commander-file?branch=master
