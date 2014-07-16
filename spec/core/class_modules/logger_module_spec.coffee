Class = modula.require('frames/class')

describe 'Frames.LoggerModule', ->

  LOG_FUNCTIONS = 'log debug info warn error'.split(' ')

  it 'adds log, debug, info, warn and error functions to prototype', ->
    for fnName in LOG_FUNCTIONS
      Class::[fnName].should.be.defined

  it 'adds log, debug, info, warn and error functions to class', ->
    for fnName in LOG_FUNCTIONS
      Class[fnName].should.be.defined

  describe '.log', ->

    beforeEach ->
      @instance = new Class()
      sinon.spy(@instance, 'logger')

    it 'calls logger with passed text', ->
      @instance.log('Test')
      @instance.logger.should.be.calledWith 'Test'

    it 'should pass options to logger', ->
      options = test: true
      @instance.log('Test', options)
      @instance.logger.should.be.calledWith 'Test', options

  describe 'helpers', ->

    HELPERS = LOG_FUNCTIONS.exclude('log')

    beforeEach ->
      @instance = new Class()
      sinon.spy(@instance, 'log')

    for helper in HELPERS
      describe ".#{helper}", ->

        it "calls log function with level: '#{helper}'", ->
          @instance[helper]('Test')
          @instance.log.should.be.calledWith 'Test', level: helper

        it 'passes options to log function', ->
          @instance[helper]('Test', test: true)
          @instance.log.should.be.calledWith 'Test', level: helper, test: true


