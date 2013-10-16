View = require('framework/view')

describe 'View', ->

  it 'inherits from Backbone.View', ->
    View::setElement.should.be.defined

  describe 'configure chain', ->

    beforeEach ->
      class @Test extends View
      @TestModule =
        testA: sinon.spy()
        testB: sinon.spy()
      Object.merge(@Test::, @TestModule)
      delete @Test.configureChain

    describe '._configure', ->

      it 'calls functions from configureChain array', ->
        @Test.configureChain = ['testA', 'testB']
        view = new @Test()
        @TestModule.testA.should.be.called
        @TestModule.testB.should.be.called

      it 'keep default Backbone.js behaviour', ->
        options = test: true
        view = new @Test(options)
        view.options.should.be.eq options

      it 'pass options to every function from configureChain', ->
        options = test: true
        @Test.configureChain = ['testA', 'testB']
        view = new @Test(options)
        @TestModule.testA.should.be.calledWith(options)
        @TestModule.testB.should.be.calledWith(options)

    describe '.addToConfigureChain', ->

      it 'creates configureChain if is not created', ->
        @Test.addToConfigureChain('test')
        @Test.configureChain.should.be.defined

      it 'adds function name to configureChain', ->
        @Test.addToConfigureChain('test')
        @Test.configureChain.should.be.eql ['test']

  describe 'remove chain', ->

    beforeEach ->
      class @Test extends View
        testA: sinon.spy()
        testB: sinon.spy()
      delete @Test.removeChain

    describe '.remove', ->

      it 'calls functions from removeChain array', ->
        @Test.addToRemoveChain('testA')
        @Test.addToRemoveChain('testB')
        test = new @Test()
        test.remove()
        test.testA.should.be.called
        test.testB.should.be.called

      it 'keeps default Backbone.js behaviour', ->
        test = new @Test()
        spy = sinon.spy(test, 'stopListening')
        test.remove()
        spy.should.be.called

    describe '.addToRemoveChain', ->

      it 'creates removeChain if is not created', ->
        @Test.addToRemoveChain('test')
        @Test.removeChain.should.be.defined

      it 'adds function name to removeChain', ->
        @Test.addToRemoveChain('test')
        @Test.removeChain.should.be.eql ['test']
