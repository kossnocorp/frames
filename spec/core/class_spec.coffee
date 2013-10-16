Class = require('framework/class')

describe 'Class', ->

  it "extends Backbone's View, Model and Collection classes with include and extend functions", ->
    ['View', 'Model', 'Collection', 'Router'].each (className) ->
      Backbone[className].include.should.be.a 'function'
      Backbone[className].extend.should.be.a 'function'

  beforeEach ->
    class @Class extends Class

  describe '.include', ->

    it 'extends class prototype with passed module', ->
      @Class.include(testA: (->), testB: (->))
      view = new @Class()
      expect(view.testA).to.be.a 'function'
      expect(view.testB).to.be.a 'function'

    describe 'included callback', ->

      beforeEach ->
        @TestModule = a: 1, b: 2
        @TestModule.included = sinon.spy()

      it 'not includes included and extended functions', ->
        @TestModule.extended = ->
        @Class.include(@TestModule)
        expect(@Class::included).to.be.not.exist
        expect(@Class::extended).to.be.not.exist

      it 'invokes included function on included', ->
        @Class.include(@TestModule)
        expect(@TestModule.included).to.be.called

      it 'calls included function with module as context', ->
        @Class.include(@TestModule)
        expect(@TestModule.included).to.be.calledOn(@TestModule)

      it 'calls included function with extended class as argument', ->
        @Class.include(@TestModule)
        expect(@TestModule.included).to.be.calledWith(@Class)

  describe '.extend', ->

    it 'extends class with passed module', ->
      @Class.extend(testA: (->), testB: (->))
      expect(@Class.testA).to.be.a 'function'
      expect(@Class.testB).to.be.a 'function'

    describe 'extended callback', ->

      beforeEach ->
        @TestModule = a: 1, b: 2
        @TestModule.extended = sinon.spy()

      it 'not extends with included and extended functions', ->
        @TestModule.included = ->
        @Class.extend(@TestModule)
        expect(@Class.included).to.not.exist
        expect(@Class.extended).to.not.exist

      it 'invokes extended function on extended', ->
        @Class.extend(@TestModule)
        expect(@TestModule.extended).to.be.called

      it 'calls extended function with module as context', ->
        @Class.extend(@TestModule)
        expect(@TestModule.extended).to.be.calledOn(@TestModule)

      it 'calls extended function with extended class as argument', ->
        @Class.extend(@TestModule)
        expect(@TestModule.extended).to.be.calledWith(@Class)

  describe 'attr reader & setter', ->

    actsAsGetter = (fnName) ->

      it 'defines getVarName function', ->
        @Class[fnName]('varName')
        expect(@Class::getVarName).to.be.defined

      it 'defines getVarName which returns instance variable named @__varName', ->
        @Class[fnName]('varName')
        ins = new @Class()
        ins.__varName = 'test'
        expect(ins.getVarName()).to.be.eq 'test'

      it 'defines isVarName if passed boolean: true', ->
        @Class[fnName]('varName', boolean: true)
        expect(@Class::isVarName).to.be.defined

      it 'allows to set custom getter name', ->
        @Class[fnName]('varName', getter: 'blahBlahBlah')
        ins = new @Class()
        ins.__varName = 'test'
        expect(ins.blahBlahBlah()).to.be.eq 'test'

    actsAsSetter = (fnName) ->

      it 'defines setVarName function', ->
        @Class[fnName]('varName')
        expect(@Class::setVarName).to.be.defined

      it 'defines setVarName which assigns passed arg to @__varName', ->
        @Class[fnName]('varName')
        ins = new @Class()
        ins.__varName = 'test'
        ins.setVarName('w00t')
        expect(ins.__varName).to.be.eq 'w00t'

      it 'allows to set custom setter name', ->
        @Class[fnName]('varName', setter: 'ugaUga')
        ins = new @Class()
        ins.__varName = 'test'
        ins.ugaUga('w00t')
        expect(ins.__varName).to.be.eq 'w00t'

      it 'allows to define quick setter for boolean variables', ->
        @Class[fnName]('subscribed', boolean: true, true: 'subscribe')
        ins = new @Class()
        ins.__subscribed = false
        ins.subscribe()
        expect(ins.__subscribed).to.be.eq true

      it 'allows to define quick inverse setter for boolean variables', ->
        @Class[fnName]('subscribed', boolean: true, false: 'unsubscribe')
        ins = new @Class()
        ins.__subscribed = true
        ins.unsubscribe()
        expect(ins.__subscribed).to.be.eq false

    describe '.attr', ->
      actsAsGetter('attr')
      actsAsSetter('attr')

    describe '.attrReader', ->
      actsAsGetter('attrReader')

    describe '.attrWriter', ->
      actsAsSetter('attrWriter')

  describe '.patch', ->

    it 'merges itself to passed object', ->
      obj = {}
      Class.patch(obj)
      expect(obj.include).to.be.a 'function'
      expect(obj.extend).to.be.a 'function'

