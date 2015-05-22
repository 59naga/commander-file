# Dependencies
Command= (require 'commander').Command
Promise= require 'bluebird'
request= Promise.promisify(require 'request')

readFile= Promise.promisify (require 'fs').readFile
path= require 'path'

# Public
class CommandFile extends Command
  constructor: (@config={})->
    super

    @config.uri?= on
    @config.file?= on
    @config.stdin?= on
    @config.timeout?= 500

  parse: ->
    super

    first= @args[0]?

    if @config.stdin and not first
      promise= new Promise (resolve)=>
        process.stdin.resume()
        process.stdin.setEncoding 'utf8'

        data= ''
        process.stdin.on 'data',(chunk)-> data+= chunk
        process.stdin.on 'end',->
          resolve data

        process.stdin.on 'data',-> clearTimeout timeoutId
        timeoutId= setTimeout (->resolve null),@timeout
    else
      promise= Promise.resolve null

    promise
    .then (data)=>
      process.stdin.pause()

      return data if data?
      return null unless first

      isUri= @args[0].match /^https?:\/\//
      if isUri and @config.uri
        uri= @args.shift()

        request uri,timeout:@config.timeout
        .spread (response,body)->
          body

      else if @config.file
        filePath= path.resolve process.cwd(),@args.shift()

        readFile filePath,'utf8'

      else
        null

    .then (data)=>
      @args.unshift data if data?
      @args

    .then =>

      this

module.exports= new CommandFile
module.exports.CommandFile= CommandFile