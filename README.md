# Commander file [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Receive stdin/file/uri at [commander.js](https://github.com/tj/commander.js)

## Installation
```bash
$ npm install commander-file
```

* Fetching filedata after [parse](https://github.com/tj/commander.js#option-parsing).
* Remove first argument unless stdin.

Example:

```js
#!/usr/bin/env node

var program = require('commander-file');
program
.usage('<stdin/file/url> dostaff [options...]')
.parse(process.argv).then(function(fileData){
  console.log(fileData);
  console.log(program.args[0]);
});
```

```bash
# stdin
$ echo -n 'foo' | node program dostaff
# foo
# dostaff

# file
$ node program bar.txt dostaff
# bar
# dostaff

# uri
$ node program http://example.com/baz.txt dostaff
# baz
# dostaff
```

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
