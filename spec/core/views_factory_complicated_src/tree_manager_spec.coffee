ViewsFactory = require('views_factory_complicated')
TreeManager = require('views_factory_complicated/tree_manager')
NodesCache = require('views_factory_complicated/nodes_cache')

describe 'TreeManager', ->

  $render = (name) ->
    $(window.__html__["spec/fixtures/complicated_views/#{name}.html"])

  it 'shares options from base ViewsFactory class in @options()', ->
    expect(TreeManager.options).to.be.equal ViewsFactory.options

  before ->
    sinon.spy(TreeManager, 'initNodes')
    sinon.spy(TreeManager, 'setParentsForInitialNodes')
    sinon.spy(TreeManager, 'setChildrenForInitialNodes')
    sinon.spy(TreeManager, 'activateNodes')
    sinon.spy(TreeManager, 'addViewNodeIdToElData')

    TreeManager.createTree()
    sinon.spy(TreeManager, 'ViewNode')
    TreeManager.ViewNode.reset()

  describe '.createTree', ->

    it 'creates viewNodes for initial dom state', ->
      expect(TreeManager.initNodes).to.be.calledOnce
      expect(TreeManager.initNodes.lastCall.args).to.be.empty

    it 'sets parents for initial viewNodes', ->
      expect(TreeManager.setParentsForInitialNodes).to.be.calledOnce
      expect(TreeManager.setParentsForInitialNodes.lastCall.args).to.be.empty

    it 'sets children for initial viewNodes', ->
      expect(TreeManager.setChildrenForInitialNodes).to.be.calledOnce
      expect(TreeManager.setChildrenForInitialNodes.lastCall.args).to.be.empty

    it 'activates initial viewNodes', ->
      expect(TreeManager.activateNodes).to.be.calledOnce
      expect(TreeManager.activateNodes.lastCall.args).to.be.empty

    it 'sets reference to ViewNode constructor in @ViewNode', ->
      expect(TreeManager.ViewNode).to.match(/ViewNode/)

  describe 'Tree building behavior', ->
    beforeEach ->
      @$els = $render('nodes_with_data_view')

      $('body').empty()
      $('body').append(@$els)
      NodesCache.clear()

    describe '.initNodes', ->
      it 'creates list of elements for specified "app" and "view" selectors and initializes viewNodes for them', ->
        initViewNodesCallCount = TreeManager.ViewNode.callCount
        TreeManager.initNodes()
        expect(TreeManager.ViewNode.callCount).to.be.eql(initViewNodesCallCount + 4)

      it 'has viewNodes pointed to corresponding dom elements in @initialNodes list', ->
        $els = $('body').find(TreeManager.viewSelector())
        expectedElsArray = $els.toArray()

        TreeManager.initNodes()
        initialNodesEls = TreeManager.initialNodes.map('el')
        expect(initialNodesEls).to.be.eql expectedElsArray

      it 'saves viewNodes to NodesCache', ->
        sinon.spy(NodesCache, 'add')
        TreeManager.initNodes()
        expect(NodesCache.add.callCount).to.be.eql 4
        NodesCache.add.reset()

    describe '.setParentsForInitialNodes', ->
      it 'sets parents for initial nodes', ->
        initialNodes = TreeManager.initialNodes

        sinon.spy(TreeManager, 'setParentsForNodes')
        TreeManager.setParentsForInitialNodes()
        expect(TreeManager.setParentsForNodes).to.be.calledOnce
        expect(TreeManager.setParentsForNodes.lastCall.args[0]).to.be.equal initialNodes
        TreeManager.setParentsForNodes.reset()

    describe '.setChildrenForInitialNodes', ->
      it 'sets children for initial nodes', ->
        initialNodes = TreeManager.initialNodes

        sinon.spy(TreeManager, 'setChildrenForNodes')
        TreeManager.setChildrenForInitialNodes()
        expect(TreeManager.setChildrenForNodes).to.be.calledOnce
        expect(TreeManager.setChildrenForNodes.lastCall.args[0]).to.be.equal initialNodes
        TreeManager.setChildrenForNodes.reset()

    describe '.setParentsForNodes', ->
      beforeEach ->
        TreeManager.initNodes()
        nodes = TreeManager.initialNodes

        $app = $('#app1')
        $view1 = $('#view1')
        $view2 = $('#view2')
        $view3 = $('#view3')

        appNodeId   = $app.data('view-node-id')
        view1NodeId = $view1.data('view-node-id')
        view2NodeId = $view2.data('view-node-id')
        view3NodeId = $view3.data('view-node-id')

        @appNode   = NodesCache.getById(appNodeId)
        @view1Node = NodesCache.getById(view1NodeId)
        @view2Node = NodesCache.getById(view2NodeId)
        @view3Node = NodesCache.getById(view3NodeId)

        TreeManager.setParentsForNodes(nodes)

      it 'looks for closest view dom element and sets it as parent for provided viewNodes', ->
        expect(@view1Node.parent).to.be.equal @appNode
        expect(@view2Node.parent).to.be.equal @appNode
        expect(@view3Node.parent).to.be.equal @view2Node

      it 'sets null reference to node parent if have no parent', ->
        expect(@appNode.parent).to.be.null

      it 'adds node to cache as root if have no parent', ->
        expect(NodesCache.showRootNodes()).to.be.eql [@appNode]
