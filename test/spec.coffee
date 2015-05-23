# Dependencies
CommandFile= (require '../src').CommandFile

# Environment
stdinData= 'foo'
file= 'test/fixture.txt'
uri= 'http://static.edgy.black/fixture.txt'

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
  describe 'Accept',->
    it 'stdin', (done)->
      stdin stdinData
      argv= command ['dostaff']

      program= new CommandFile
      program.parse(argv).then (data)->

        expect(data).toBe 'foo'
        expect(program.args[0]).toBe 'dostaff'
        done()

    it 'file', (done)->
      stdin null
      argv= command [file,'dostaff']

      program= new CommandFile
      program.parse(argv).then (data)->

        expect(data).toBe 'bar'
        expect(program.args[0]).toBe 'dostaff'
        done()

    it 'url', (done)->
      stdin null
      argv= command [uri,'dostaff']

      program= new CommandFile
      program.parse(argv).then (data)->

        expect(data).toBe 'baz\n'
        expect(program.args[0]).toBe 'dostaff'
        done()

  describe 'Note',->
    it 'Root is instanceof CommandFile',(done)->
      stdin stdinData
      argv= command ['dostaff']

      program= require '../src'
      program.parse(argv).then (data)->

        expect(program instanceof CommandFile).toBe true
        expect(data).toBe stdinData
        expect(program.args[0]).toBe 'dostaff'
        done()

    it 'Default file extension ex: package -> package.json',(done)->
      stdin null
      argv= command ['package','dostaff']

      program= new CommandFile fileExtension:'.json'
      program.parse(argv).then (data)->

        expect(data).toBeTruthy()
        expect(program.args[0]).toBe 'dostaff'
        done()

    it 'All denny( ≈ commander)',(done)->
      stdin 'foo'
      argv= command ['test/fixture.txt']

      program= new CommandFile {uri:off,file:off,stdin:off}
      program.parse(argv).then (data)->

        expect(data).toBe null
        done()
