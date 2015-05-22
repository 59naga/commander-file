# Dependencies
CommandFile= (require '../src').CommandFile

# Fixtures
stdin= (data)->
  return unless data

  process.nextTick ->
    process.stdin.emit 'data',data
    process.stdin.emit 'end'

command= (args...)->
  argv= ['node',__filename]
  argv.concat args...

# Specs
describe 'CommandFile',->
  it 'shorthand',(done)->
    stdin 'foo'
    argv= command []

    program= require '../src'
    program.parse(argv).then (result)->

      expect(result).toBe program
      expect(result.args).toEqual ['foo']
      done()

  describe 'All accepts',->
    it 'stdin', (done)->
      stdin 'foo'
      argv= command []

      program= new CommandFile
      program.parse(argv).then ->

        expect(program.args).toEqual ['foo']
        done()

    it 'file', (done)->
      stdin ''
      argv= command ['test/fixture.txt']

      program= new CommandFile
      program.parse(argv).then ->

        expect(program.args).toEqual ['bar']
        done()

    it 'url', (done)->
      stdin ''
      argv= command ['http://static.edgy.black/fixture.txt']

      program= new CommandFile
      program.parse(argv).then ->

        expect(program.args).toEqual ['baz\n']
        done()

    it 'timeout 500ms', (done)->
      stdin ''
      argv= command ['https://static.edgy.black/fixture.txt']

      program= new CommandFile
      program.parse(argv).catch Error,(error)->

        expect(error.message).toBe 'ETIMEDOUT'
        done()

  it 'All denny( ≈ commander)',(done)->
    stdin 'foo'
    argv= command ['test/fixture.txt']

    program= new CommandFile {uri:off,file:off,stdin:off}
    program.parse(argv).then ->

      expect(program.args).toEqual ['test/fixture.txt']
      done()
