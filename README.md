# Commander file [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

> Receive file/uri and stdin at [commander.js](https://github.com/tj/commander.js)

## Installation
```bash
$ npm install commander-file
```

* Fetch data after [parse](https://github.com/tj/commander.js#option-parsing) via first argument or `--stdin`.
* First argument always return the file.

# Usage

program.js

```js
#!/usr/bin/env node

var program = require('commander-file');
program
.usage('<file/url> dostaff [options...]')
.parse(process.argv).then(function(data){
  console.log(data);
  console.log(program.args[0]);
  console.log(program.args[1]);
});
```

```bash
$ node program.js --help
#
#  Usage: program <file/url> dostaff [options...]
#
#  Options:
#
#    -h, --help   output usage information
#    -S, --stdin  use the stdin.

# stdin
$ echo -n 'foo' | node program.js --stdin dostaff
# foo
# null
# dostaff

$ node program.js bar.txt dostaff
# bar
# bar.txt
# dostaff

# uri
$ node program.js http://example.com/baz.txt dostaff
# baz
# http://example.com/baz.txt
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
