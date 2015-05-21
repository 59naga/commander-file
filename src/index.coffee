# Dependencies
Command= (require 'commander').Command
Promise= require 'bluebird'

class CommandFile extends Command
  constructor: (argv,@options={})->
    super

    @options.timeout?= 500
    @options.encoding?= 'utf8'

    @parse argv

  parse: ->
    new Promise (resolve)=>
      process.stdin.resume()
      process.stdin.setEncoding @options.encoding

      data= ''
      process.stdin.on 'data',(chunk)-> data+= chunk
      process.stdin.on 'end',->
        resolve data

      process.stdin.on 'data',-> clearTimeout timeoutId
      timeoutId= setTimeout (->resolve data),@timeout

    .then (data)=>
      process.stdin.pause()

      fileRequest= not file and @args.length
      if fileRequest
        filePath= path.resolve process.cwd(),@args.shift()
        if @options.encoding?
          data= fs.readFileSync filePath,@options.encoding
        else
          data= fs.readFileSync filePath

      @args.unshift data 

      this

module.exports= CommandFile