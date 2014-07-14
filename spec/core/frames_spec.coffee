Frames = modula.require('frames')

describe 'Frames', ->

  describe 'launcher functional', ->

    beforeEach ->
      @contructorSpy = contructorSpy = sinon.spy()
      @hookSpy = hookSpy = sinon.spy()
      @Launcher = class
        constructor: contructorSpy
        hook: hookSpy

    describe '@registerLauncher', ->

      it 'creates instance of passed launcher', ->
        Frames.registerLauncher(@Launcher)
        expect(@contructorSpy).to.be.called

    describe '@hook', ->

      it 'delegates hook call to registered launcher', ->
        callback = ->
        Frames.registerLauncher(@Launcher)
        Frames.hook('test', callback)
        expect(@hookSpy).to.be.calledWith('test', callback)

      it 'throws error if launcher is not registred', ->
        Frames.__launcher = undefined
        expect(-> Frames.hook('test', ->)).to.throw 'Launcher is not registered'

  describe 'factories functional', ->

    createFakeFactory = ->
      class
        @create: sinon.spy()
        @destroy: sinon.spy()

    beforeEach ->
      Frames.factories = undefined
      @FakeFactory = createFakeFactory()

    describe '@start', ->

      it 'runs create for every registred factory', ->
        Frames.registerFactory(@FakeFactory)
        Frames.start()
        expect(@FakeFactory.create).to.be.called

    describe '@stop', ->

      it 'calls destroy for every registred factory', ->
        Frames.registerFactory(@FakeFactory)
        Frames.stop()
        expect(@FakeFactory.destroy).to.be.called

    describe '@registerFactory', ->

      it 'saves class to factories', ->
        Frames.registerFactory(@FakeFactory)
        expect(Object.values(Frames.factories)).to.be.eql [@FakeFactory]

      it 'allows to register one factory per id', ->
        FakeFactoryA = createFakeFactory()
        FakeFactoryB = createFakeFactory()
        Frames.registerFactory(@FakeFactory)
        Frames.registerFactory(FakeFactoryA, 'w00t')
        Frames.registerFactory(FakeFactoryB, 'w00t')
        expect(Object.values(Frames.factories)).to.be.eql [@FakeFactory, FakeFactoryB]

      it 'returns factory id', ->
        expect(Frames.registerFactory(@FakeFactory, 'w00t')).to.be.eq 'w00t'

