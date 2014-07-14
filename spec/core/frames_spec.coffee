Frames = modula.require('frames')

describe 'Frames', ->

  describe 'extendables modules api', ->
    beforeEach ->
      Frames.Extendables.Module1 = class
        extended: ->
        ready: ->
      Frames.Extendables.Module2 =  class
        extended: ->

      sinon.spy(Frames.Extendables, 'Module1')
      sinon.spy(Frames.Extendables, 'Module2')

    afterEach ->
      Frames.Extendables = {}

    it 'has .Extendables child namespace', ->
      expect(Frames).to.have.property 'Extendables'

    describe '@createExtendables', ->
      it 'initializes extendable modules', ->
        Frames.createExtendables()
        expect(Frames.Extendables.Module1).to.be.calledOnce
        expect(Frames.Extendables.Module2).to.be.calledOnce

      it 'saves extendable modules in @extendables with underscored keys', ->
        Frames.createExtendables()
        expect(Frames.extendables['module1']).to.be.instanceOf Frames.Extendables.Module1
        expect(Frames.extendables['module2']).to.be.instanceOf Frames.Extendables.Module2

      it 'throws error if #extended method is not specified for extendable module', ->
        Frames.Extendables.Module2 =  class
        expect(-> Frames.createExtendables()).to.throw 'Trying to initialize extendable module, but #extended method is not specified for it.'

    describe '@extend', ->
      context 'extendable module is specified', ->
        it 'calls #extended method of registred extendable module', ->
          sinon.spy(Frames.extendables['module1'], 'extended')
          arg1 = 'First extension argument'
          arg2 = 'Second extension argument'

          expect(Frames.extendables['module1'].extended).to.not.be.called
          Frames.extend('module1', arg1, arg2)
          expect(Frames.extendables['module1'].extended).to.be.calledOnce
          expect(Frames.extendables['module1'].extended.lastCall.args).to.be.eql [arg1, arg2]

      context 'extendable module is not specified', ->
        it 'throws error', ->
          arg1 = 'First extension argument'
          expect(-> Frames.extend('module3', arg1)).to.throw 'Trying to extend module Module3, but it is not registered.'

    describe '@start', ->
      it 'calls #ready method for each initialized extendable module', ->
        readyFn = sinon.spy(Frames.extendables['module1'], 'ready')
        Frames.start()
        expect(readyFn).to.be.called

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

