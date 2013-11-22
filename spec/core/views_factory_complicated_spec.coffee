ViewsFactory = require('views_factory_complicated')
TreeManager = require('views_factory_complicated/tree_manager')

describe 'ViewsFactory', ->

  $render = (name) ->
    $(window.__html__["spec/fixtures/complicated_views/#{name}.html"])

  describe '.initRemoveEvent', ->
    it 'creates custom jquery event, which being triggered when element being removed from DOM', ->
      ViewsFactory.initRemoveEvent()
      fnSpy = sinon.spy()
      $el = $('<div />')
      $el2 = $('<div />')

      $('body').append($el).append($el2)
      $el.on('remove', fnSpy)
      $el2.on('remove', fnSpy)
      $el.remove()
      $el2.remove()

      expect(fnSpy).to.be.calledTwice

  describe '.create', ->
    it 'initializes TreeManager instance', ->
      sinon.spy(ViewsFactory, 'initTreeManager')
      ViewsFactory.create()
      expect(ViewsFactory.initTreeManager).to.be.calledOnce

    it 'initializes custom jquery remove event', ->
      sinon.spy(ViewsFactory, 'initRemoveEvent')
      ViewsFactory.create()
      expect(ViewsFactory.initRemoveEvent).to.be.calledOnce

    it 'initializes custom jquery refresh event', ->
      sinon.spy(ViewsFactory, 'initRefreshEvent')
      ViewsFactory.create()
      expect(ViewsFactory.initRefreshEvent).to.be.calledOnce

    it 'creates views tree', ->
      sinon.spy(ViewsFactory, 'createViewsTree')
      ViewsFactory.create()
      expect(ViewsFactory.createViewsTree).to.be.calledOnce

  describe '.initTreeManager', ->
    it 'saves reference to new TreeManager instance in @treeManager', ->
      ViewsFactory.initTreeManager()
      expect(ViewsFactory.treeManager).to.be.instanceOf(TreeManager)

  describe '.createViewsTree', ->
    it 'creates view tree with help of @treeManager', ->
      sinon.spy(ViewsFactory.treeManager, 'createTree')
      ViewsFactory.createViewsTree()
      expect(ViewsFactory.treeManager.createTree).to.be.calledOnce

  describe '.initRefreshEvent', ->
    it 'creates custom jquery refresh event', ->
      ViewsFactory.initRefreshEvent()
      expect(ViewsFactory.isRefreshEventInitialized()).to.be.true

    describe 'Custom jquery refresh event', ->
      before ->
        ViewsFactory.initRefreshEvent()
        @treeManager = ViewsFactory.treeManager
        sinon.spy(@treeManager, 'refresh')

      beforeEach ->
        $('body').empty().append($render('nodes_with_data_view'))
        @treeManager.createTree()

      it "calls tree manager's refresh event", ->
        initCallCount = @treeManager.refresh.callCount
        $el = $('body').find('#app1')
        $el.trigger('refresh')
        expect(@treeManager.refresh.callCount).to.be.eql(initCallCount + 1)

      it 'looks for closest element with initialized viewNode', ->
        $elWithoutView = $('body').find('#no_view')
        $closestWithView = $('body').find('#app1')
        $elWithoutView.trigger('refresh')

        viewNode = @treeManager.refresh.lastCall.args[0]
        expect(viewNode.el).to.be.equal $closestWithView[0]

      it 'refreshes element if it has viewNode', ->
        $el = $('body').find('#view2')
        $el.trigger('refresh')

        viewNode = @treeManager.refresh.lastCall.args[0]
        expect(viewNode.el).to.be.equal $el[0]
