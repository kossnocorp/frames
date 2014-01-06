Frames = require('frames')
Launcher = require('frames/launcher')

describe 'Launcher', ->

  beforeEach ->
    @originBindReady = Launcher::bindReady
    readyList = []
    Launcher::bindReady = (fn) -> readyList.push(fn)
    @ready = -> fn() for fn in readyList

    @launcher = new Launcher()
    @launcher.reset()

  afterEach ->
    Launcher::bindReady = @originBindReady

  describe 'initialization stages', ->

    describe 'loaded stage', ->

      it 'initiates right after launcher is loaded and registered', ->
        expect(@launcher.getState()).to.be.eq 'loaded'

    describe 'ready stage', ->

      beforeEach ->
        @startSpy = sinon.spy(Frames, 'start')

      afterEach ->
        @startSpy.restore()

      it 'initiates once DOM is ready', ->
        spy = sinon.spy()
        @ready()
        expect(@launcher.getState()).to.be.eq 'ready'

      it 'calls Frames.start', ->
        expect(@startSpy).to.not.be.called
        @ready()
        expect(@startSpy).to.be.called

      it 'calls attached hooks before Frames.start is called'

    describe 'created stage', ->

      it 'initiates right after Frames.start is worked'

  describe '::reset', ->

    it 'resets launcher to initial state', ->
      @launcher.setState('test')
      @launcher.reset()
      expect(@launcher.getState()).to.be.eq 'loaded'

  describe 'hook function', ->

    it 'calls hook immediately if stage is already initiated'

    it 'calls hook immediately if next stage(s) is initiated'

    it 'calls hooks asynchronous'

    describe 'pause function', ->

      it 'pauses initialization process until unpause will be called'

      it "holds next stage until all unpause's will be called"
