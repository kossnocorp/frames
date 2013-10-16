Framework = require('framework')

describe 'Framework', ->

  describe 'factories functional', ->

    createFakeFactory = ->
      class
        @create: sinon.spy()
        @destroy: sinon.spy()

    beforeEach ->
      Framework.factories = undefined
      @FakeFactory = createFakeFactory()

    describe '@start', ->

      it 'runs create for every registred factory', ->
        Framework.registerFactory(@FakeFactory)
        Framework.start()
        expect(@FakeFactory.create).to.be.called

    describe '@stop', ->

      it 'calls destroy for every registred factory', ->
        Framework.registerFactory(@FakeFactory)
        Framework.stop()
        expect(@FakeFactory.destroy).to.be.called

    describe '@registerFactory', ->

      it 'saves class to factories', ->
        Framework.registerFactory(@FakeFactory)
        expect(Object.values(Framework.factories)).to.be.eql [@FakeFactory]

      it 'allows to register one factory per id', ->
        FakeFactoryA = createFakeFactory()
        FakeFactoryB = createFakeFactory()
        Framework.registerFactory(@FakeFactory)
        Framework.registerFactory(FakeFactoryA, 'w00t')
        Framework.registerFactory(FakeFactoryB, 'w00t')
        expect(Object.values(Framework.factories)).to.be.eql [@FakeFactory, FakeFactoryB]

      it 'returns factory id', ->
        expect(Framework.registerFactory(@FakeFactory, 'w00t')).to.be.eq 'w00t'

  describe '@export', ->

    describe 'when modula is not defined', ->

      beforeEach ->
        @_modula = window.modula
        delete window.modula
        @TestModule = {}

      afterEach ->
        window.modula = @_modula

      it 'saves exports as name into window', ->
        Framework.export('test_module', @TestModule)
        expect(window.TestModule).to.be.eq @TestModule
        delete window.TestModule

      it 'uses slash as namespace devider', ->
        Framework.export('test/module', @TestModule)
        expect(Test.Module).to.be.eq @TestModule
        delete window.Test

    describe 'when modula is defined', ->

      it 'calls modula export', ->
        spy = sinon.spy(modula, 'export')
        Framework.export('test_module', @TestModule)
        expect(spy).to.be.calledWith('test_module', @TestModule)
        spy.restore()
