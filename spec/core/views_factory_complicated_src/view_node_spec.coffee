ViewsFactory = require('views_factory_complicated')
ViewNode = require('views_factory_complicated/view_node')

describe 'ViewNode', ->

  before ->
    sinon.spy(ViewNode::, 'init')
    sinon.spy(ViewNode::, 'activate')
    sinon.spy(ViewNode::, 'unload')
    sinon.spy(ViewNode::, 'setAsActivated')
    sinon.spy(ViewNode::, 'setAsRemoved')

  beforeEach ->
    ViewsFactory.options = {viewSelector: 'some_strange_selector'}

    @$el = $('div')
    @$secondEl = $('div')
    @$thirdEl = $('div')
    @$fourthEl = $('div')

    @viewNode = new ViewNode(@$el)
    @secondViewNode = new ViewNode(@$secondEl)
    @thirdViewNode = new ViewNode(@$thirdEl)
    @fourthViewNode = new ViewNode(@$fourthEl)

  describe '.constructor', ->
    it 'shares options from base ViewsFactory class', ->
      expect(@viewNode.options).to.be.equal ViewsFactory.options

    it 'has uniq id', ->
      ids = [@viewNode.id, @secondViewNode.id, @thirdViewNode.id]
      expect(ids.unique()).to.have.length 3

    it 'has reference to provided jquery dom element', ->
      expect(@viewNode.$el).to.be.equal @$el
      expect(@viewNode.el).to.be.equal @$el[0]

    it 'has null reference for @parent', ->
      expect(@viewNode.parent).to.be.null

    it 'has empty list reference for @children', ->
      expect(@viewNode.children).to.be.an('array')
      expect(@viewNode.children).to.be.eql []

    it 'calls .init method', ->
      expect(@viewNode.init).to.be.called

  describe '.setParent', ->
    it 'sets provided ViewNode instance as @parent', ->
      @viewNode.setParent(@secondViewNode)
      expect(@viewNode.parent).to.be.equal @secondViewNode

  describe '.setChildren', ->
    it 'creates list of provided viewNodes array, which parent is current node and saves them as @children', ->
      @secondViewNode.setParent(@viewNode)
      @fourthViewNode.setParent(@viewNode)

      @viewNode.setChildren([@secondViewNode, @thirdViewNode, @fourthViewNode])
      expect(@viewNode.children).to.be.eql [@secondViewNode, @fourthViewNode]

  describe '.removeChild', ->
    it 'removes provided child from @children', ->
      @secondViewNode.setParent(@viewNode)
      @fourthViewNode.setParent(@viewNode)

      @viewNode.setChildren([@secondViewNode, @fourthViewNode])
      @viewNode.removeChild(@secondViewNode)
      expect(@viewNode.children).to.be.eql [@fourthViewNode]

    it 'does nothing if provided child is not in @children', ->
      @secondViewNode.setParent(@viewNode)
      @fourthViewNode.setParent(@viewNode)

      @viewNode.setChildren([@secondViewNode, @fourthViewNode])
      @viewNode.removeChild(@thirdViewNode)
      expect(@viewNode.children).to.be.eql [@secondViewNode, @fourthViewNode]

  describe 'Initialization behavior', ->

    before ->
      @callback = sinon.spy()
      @secondCallback = sinon.spy()
      @thirdCallback = sinon.spy()

      ViewNode.onInit(@callback)
      ViewNode.onInit(@secondCallback)
      ViewNode.onInit(@thirdCallback)

    describe '#onInit', ->
      it 'saves reference to provided callback inside @onInitCallbacks()', ->
        expect(@viewNode.onInitCallbacks()).to.be.eql [@callback, @secondCallback, @thirdCallback]

    describe '.init', ->
      it 'calls @onInitCallbacks() callbacks one by one', ->
        @viewNode.init()

        expect(@callback).to.be.called.once
        expect(@secondCallback).to.be.called.once
        expect(@callback).to.be.calledBefore(@secondCallback)
        expect(@secondCallback).to.be.calledBefore(@thirdCallback)

      it 'calls callbacks with current viewNode instance as first argument', ->
        @viewNode.init()
        expect(@callback.lastCall.args[0]).to.be.equal @viewNode

        @secondViewNode.init()
        expect(@callback.lastCall.args[0]).to.be.equal @secondViewNode

  describe 'Activation behavior', ->

    before ->
      @callback = sinon.spy()
      @secondCallback = sinon.spy()
      @thirdCallback = sinon.spy()

      ViewNode.onActivation(@callback)
      ViewNode.onActivation(@secondCallback)
      ViewNode.onActivation(@thirdCallback)

    describe '#onActivation', ->
      it 'saves reference to provided callback inside @onActivationCallbacks()', ->
        expect(@viewNode.onActivationCallbacks()).to.be.eql [@callback, @secondCallback, @thirdCallback]

    describe '.activate', ->
      it 'marks viewNode as activated', ->
        @viewNode.activate()
        expect(@viewNode.isActivated()).to.be.true

      it 'calls @onActivationCallbacks() callbacks one by one', ->
        @viewNode.activate()

        expect(@callback).to.be.called.once
        expect(@secondCallback).to.be.called.once
        expect(@callback).to.be.calledBefore(@secondCallback)
        expect(@secondCallback).to.be.calledBefore(@thirdCallback)

      it 'calls callbacks with current viewNode instance as first argument', ->
        @viewNode.activate()
        expect(@callback.lastCall.args[0]).to.be.equal @viewNode

        @secondViewNode.activate()
        expect(@callback.lastCall.args[0]).to.be.equal @secondViewNode

      it 'does nothing if viewNode is already activated', ->
        @viewNode.activate()
        initSetAsActivatedCallsCount = @viewNode.setAsActivated.callCount

        @viewNode.activate()
        expect(@viewNode.setAsActivated.callCount).to.be.eql initSetAsActivatedCallsCount


  describe 'Unload behavior', ->

    before ->
      @callback = sinon.spy()
      @secondCallback = sinon.spy()
      @thirdCallback = sinon.spy()

      ViewNode.onUnload(@callback)
      ViewNode.onUnload(@secondCallback)
      ViewNode.onUnload(@thirdCallback)

    describe '#onUnload', ->
      it 'saves reference to provided callback inside @onUnloadCallbacks()', ->
        expect(@viewNode.onUnloadCallbacks()).to.be.eql [@callback, @secondCallback, @thirdCallback]

    describe '.unload', ->
      it 'calls @onUnloadCallbacks() callbacks one by one', ->
        @viewNode.unload()

        expect(@callback).to.be.called.once
        expect(@secondCallback).to.be.called.once
        expect(@callback).to.be.calledBefore(@secondCallback)
        expect(@secondCallback).to.be.calledBefore(@thirdCallback)

      it 'calls callbacks with current viewNode instance as first argument', ->
        @viewNode.unload()
        expect(@callback.lastCall.args[0]).to.be.equal @viewNode

        @secondViewNode.unload()
        expect(@callback.lastCall.args[0]).to.be.equal @secondViewNode

      it 'sets viewNode as not activated', ->
        @viewNode.activate()
        @viewNode.unload()
        expect(@viewNode.isActivated()).to.be.false

  describe 'Remove behavior', ->

    describe '.remove', ->
      it 'sets viewNode as removed', ->
        @viewNode.remove()
        expect(@viewNode.isRemoved()).to.be.true

      it 'unloads viewNode only if viewNode is activated', ->
        initUnloadCallsCount = @viewNode.unload.callCount

        @viewNode.remove()
        expect(@viewNode.unload.callCount).to.be.eql(initUnloadCallsCount)

        @secondViewNode.activate()
        @secondViewNode.remove()
        expect(@secondViewNode.unload.callCount).to.be.eql(initUnloadCallsCount + 1)

      it 'does nothing if viewNode is already removed', ->
        @viewNode.activate()
        @viewNode.remove()

        initSetAsRemovedCallsCount = @viewNode.setAsRemoved.callCount

        @viewNode.remove()
        expect(@viewNode.setAsRemoved.callCount).to.be.eql initSetAsRemovedCallsCount
