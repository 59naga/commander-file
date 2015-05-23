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
    @config.stdinTimeout?= 500

    @config.file?= on
    @config.fileExtension?= ''

    @config.uri?= on
    @config.uriTimeout?= 0

    @config.alignStaffArguments?= on

  parse: ->
    super

    stdin=
      if @config.stdin
        new Promise (resolve)=>
          process.stdin.resume()
          process.stdin.setEncoding 'utf8'

          data= ''
          process.stdin.on 'data',(chunk)-> data+= chunk
          process.stdin.on 'end',->
            resolve data

          process.stdin.on 'data',-> clearTimeout timeoutId
          timeoutId= setTimeout (->resolve null),@stdinTimeout
      else
        Promise.resolve null

    stdin.then (data)=>
      process.stdin.pause()

      firstArg= @args[0]

      return data if data?
      return null unless firstArg

      @args.shift() if @config.alignStaffArguments

      isUri= firstArg.match /^https?:\/\//
      if isUri and @config.uri
        uri= firstArg

        request uri,timeout:@config.uriTimeout
        .spread (response,body)->
          body

      else if @config.file
        filePath= path.resolve process.cwd(),firstArg

        filePath+=
          if not @config.fileExtension
            ''
          else
            found= fs.existsSync path.resolve process.cwd(),filePath
            shorthand= (path.basename filePath).match /^\w+$/

            @config.fileExtension if not found and shorthand

        readFileAsync filePath,'utf8'

      else
        null

module.exports= new CommandFile
module.exports.CommandFile= CommandFile