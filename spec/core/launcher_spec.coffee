Frames = require('frames')
Launcher = require('frames/launcher')

describe 'Launcher', ->

  beforeEach ->
    @originBindReady = Launcher::__bindReady
    readyList = []
    Launcher::__bindReady = (fn) -> readyList.push(fn)
    @ready = -> fn() for fn in readyList

    @originCall = Launcher::__call
    Launcher::__call = (fn) -> try fn() catch

    @launcher = new Launcher()
    @launcher.reset()

    @startSpy = sinon.spy(Frames, 'start')

  afterEach ->
    Launcher::__bindReady = @originBindReady
    Launcher::__call = @originCall
    @startSpy.restore()

  describe 'initialization stages', ->

    describe 'loaded stage', ->

      it 'initiates right after launcher is loaded and registered', ->
        expect(@launcher.getStage()).to.be.eq 'loaded'

    describe 'ready stage', ->

      it 'initiates once DOM is ready', ->
        @ready()
        expect(@launcher.getStage()).to.be.eq 'ready'

      it 'calls Frames.start', ->
        expect(@startSpy).to.not.be.called
        @ready()
        expect(@startSpy).to.be.called

      it 'calls attached hooks before Frames.start is called', ->
        callbackA = sinon.spy()
        callbackB = sinon.spy()
        @launcher.hook('ready', callbackA)
        @launcher.hook('ready', callbackB)
        @ready()
        expect(callbackA).to.be.calledBefore(@startSpy)
        expect(callbackB).to.be.calledBefore(@startSpy)

    describe 'created stage', ->

      it 'initiates right after Frames.start is worked', (done) ->
        callbackA = sinon.spy()
        callbackB = sinon.spy()
        @launcher.hook('created', callbackA)
        @launcher.hook('created', callbackB)
        @ready()
        setTimeout(
          =>
            expect(callbackA).to.be.calledAfter(@startSpy)
            expect(callbackB).to.be.calledAfter(@startSpy)
            done()
          0
        )

  describe '::reset', ->

    it 'resets launcher to initial state', ->
      @ready()
      expect(@launcher.getStage()).to.be.eq 'ready'
      @launcher.reset()
      expect(@launcher.getStage()).to.be.eq 'loaded'

  describe 'hook function', ->

    it 'calls hook immediately if stage is already initiated', ->
      callback = sinon.spy()
      @ready()
      @launcher.hook('ready', callback)
      expect(@launcher.getStage()).to.be.eq 'ready'
      expect(callback).to.be.called

    it 'calls hook immediately if next stage(s) is initiated', ->
      callback = sinon.spy()
      @ready()
      @launcher.hook('loaded', callback)
      expect(@launcher.getStage()).to.be.eq 'ready'
      expect(callback).to.be.called

    it 'calls hooks asynchronous', ->
      callbackA = sinon.spy()
      callbackB = sinon.spy()
      @launcher.hook('ready', callbackA)
      @launcher.hook('ready', -> throw 'Ooops')
      @launcher.hook('ready', callbackB)
      @ready()
      expect(callbackA).to.be.called
      expect(callbackB).to.be.called

    describe 'pause function', ->

      it 'pauses initialization process until unpause will be called'

      it 'holds next stage until all unpauses will be called'
