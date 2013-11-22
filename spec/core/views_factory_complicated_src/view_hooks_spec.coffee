ViewHooks = require('views_factory_complicated/view_hooks')

describe 'ViewHooks', ->

  beforeEach ->
    @viewHook = new ViewHooks()
    @callback = sinon.spy()
    @secondCallback = sinon.spy()
    @thirdCallback = sinon.spy()

  describe 'Initialization behavior', ->

    describe '.onInit', ->
      it 'saves reference to provided callback inside @onInitCallbacks()', ->
        @viewHook.onInit(@callback)
        @viewHook.onInit(@secondCallback)
        @viewHook.onInit(@thirdCallback)

        expect(@viewHook.onInitCallbacks()).to.be.eql [@callback, @secondCallback, @thirdCallback]

    describe '.init', ->
      it 'calls @onInitCallbacks() callbacks one by one', ->
        @viewHook.onInit(@callback)
        @viewHook.onInit(@secondCallback)
        @viewHook.onInit(@thirdCallback)
        @viewHook.init()

        expect(@callback).to.be.called.once
        expect(@secondCallback).to.be.called.once
        expect(@callback).to.be.calledBefore(@secondCallback)
        expect(@secondCallback).to.be.calledBefore(@thirdCallback)

      it 'calls @onInitCallbacks() callbacks with provided arguments', ->
        arg1 = 'argument 1'
        arg2 = 'argument 2'

        @viewHook.onInit(@callback)
        @viewHook.onInit(@secondCallback)
        @viewHook.init(arg1, arg2)

        expect(@callback.lastCall.args).to.be.eql [arg1, arg2]
        expect(@secondCallback.lastCall.args).to.be.eql [arg1, arg2]

  describe 'Activation behavior', ->

    describe '.onActivation', ->
      it 'saves reference to provided callback inside @onActivationCallbacks()', ->
        @viewHook.onActivation(@callback)
        @viewHook.onActivation(@secondCallback)
        @viewHook.onActivation(@thirdCallback)

        expect(@viewHook.onActivationCallbacks()).to.be.eql [@callback, @secondCallback, @thirdCallback]

    describe '.activate', ->
      it 'calls @onActivationCallbacks() callbacks one by one', ->
        @viewHook.onActivation(@callback)
        @viewHook.onActivation(@secondCallback)
        @viewHook.onActivation(@thirdCallback)
        @viewHook.activate()

        expect(@callback).to.be.called.once
        expect(@secondCallback).to.be.called.once
        expect(@callback).to.be.calledBefore(@secondCallback)
        expect(@secondCallback).to.be.calledBefore(@thirdCallback)

      it 'calls @onActivationCallbacks() callbacks with provided arguments', ->
        arg1 = 'argument 1'
        arg2 = 'argument 2'

        @viewHook.onActivation(@callback)
        @viewHook.onActivation(@secondCallback)
        @viewHook.activate(arg1, arg2)

        expect(@callback.lastCall.args).to.be.eql [arg1, arg2]
        expect(@secondCallback.lastCall.args).to.be.eql [arg1, arg2]

  describe 'Unload behavior', ->

    describe '.onUnload', ->
      it 'saves reference to provided callback inside @onUnloadCallbacks()', ->
        @viewHook.onUnload(@callback)
        @viewHook.onUnload(@secondCallback)
        @viewHook.onUnload(@thirdCallback)

        expect(@viewHook.onUnloadCallbacks()).to.be.eql [@callback, @secondCallback, @thirdCallback]

    describe '.unload', ->
      it 'calls @onUnloadCallbacks() callbacks one by one', ->
        @viewHook.onUnload(@callback)
        @viewHook.onUnload(@secondCallback)
        @viewHook.onUnload(@thirdCallback)
        @viewHook.unload()

        expect(@callback).to.be.called.once
        expect(@secondCallback).to.be.called.once
        expect(@callback).to.be.calledBefore(@secondCallback)
        expect(@secondCallback).to.be.calledBefore(@thirdCallback)

      it 'calls @onUnloadCallbacks() callbacks with provided arguments', ->
        arg1 = 'argument 1'
        arg2 = 'argument 2'

        @viewHook.onUnload(@callback)
        @viewHook.onUnload(@secondCallback)
        @viewHook.unload(arg1, arg2)

        expect(@callback.lastCall.args).to.be.eql [arg1, arg2]
        expect(@secondCallback.lastCall.args).to.be.eql [arg1, arg2]
