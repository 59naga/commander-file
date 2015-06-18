# Dependencies
Command= (require 'commander').Command
Promise= require 'bluebird'
request= Promise.promisify(require 'request')

fs= require 'fs'
path= require 'path'
readFileAsync= Promise.promisify fs.readFile

# Public
class CommandFile extends Command
  constructor: (@config={})->
    super

    @config.stdin?= on

    @config.file?= on
    @config.fileExtension?= ''

    @config.uri?= on
    @config.uriTimeout?= 0

    if @config.stdin
      @option '-S, --stdin','use the stdin'

  parse: ->
    super

    stdin=
      if @stdin
        @parseStdin()
      else
        Promise.resolve null

    stdin.then (data)=>
      process.stdin.pause()

      firstArg= @args[0]

      return data if data? and data.length
      return null unless firstArg

      isUri= firstArg.match /^https?:\/\//
      if isUri and @config.uri
        uri= firstArg

        request uri,timeout:@config.uriTimeout
        .spread (response,body)->
          body

      else if @config.file
        @parseFile firstArg

      else
        null

  parseStdin: ->
    @args.unshift null
    
    new Promise (resolve)->
      process.stdin.resume()
      process.stdin.setEncoding 'utf8'

      data= ''
      process.stdin.on 'data',(chunk)->
        data+= chunk
      process.stdin.on 'end',->
        resolve data

  parseFile: (filename)->
    filePath= path.resolve process.cwd(),filename

    found= fs.existsSync path.resolve process.cwd(),filePath
    shorthand= (path.basename filePath).match /^\w+$/

    filePath+=
      if shorthand and @config.fileExtension and not found
        @config.fileExtension
      else
        ''
    
    readFileAsync filePath,'utf8'

module.exports= new CommandFile
module.exports.CommandFile= CommandFile