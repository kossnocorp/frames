ViewsFactory = require('views_factory_complicated')
TreeManager = require('views_factory_complicated/tree_manager')
NodesCache = require('views_factory_complicated/nodes_cache')

describe 'TreeManager', ->

  $render = (name) ->
    $(window.__html__["spec/fixtures/complicated_views/#{name}.html"])

  beforeEach ->
    @treeManager = new TreeManager
    sinon.spy(@treeManager, 'setInitialNodes')
    sinon.spy(@treeManager, 'setParentsForInitialNodes')
    sinon.spy(@treeManager, 'setChildrenForInitialNodes')
    sinon.spy(@treeManager, 'activateInitialNodes')
    sinon.spy(@treeManager, 'setParentsForNodes')
    sinon.spy(@treeManager, 'setChildrenForNodes')
    sinon.spy(@treeManager, 'activateNodes')

  describe '.constructor', ->
    it 'shares options from base ViewsFactory class', ->
      expect(@treeManager.options).to.be.equal ViewsFactory.options

    it 'sets reference to ViewNode constructor in @ViewNode', ->
      expect(@treeManager.ViewNode).to.match(/ViewNode/)

    it 'creates NodesCache instance in @nodesCache', ->
      expect(@treeManager.nodesCache).to.be.instanceOf(NodesCache)

    it 'has empty @initialNodes list', ->
      expect(@treeManager.initialNodes).to.be.an('array')
      expect(@treeManager.initialNodes).to.be.eql []

  describe '.createTree', ->
    beforeEach ->
      @treeManager.createTree()
      @initialNodes = @treeManager.initialNodes

    it 'creates viewNodes for initial dom state', ->
      expect(@treeManager.setInitialNodes).to.be.calledOnce

    it 'sets parents for initial viewNodes', ->
      expect(@treeManager.setParentsForInitialNodes).to.be.calledOnce

    it 'sets children for initial viewNodes', ->
      expect(@treeManager.setChildrenForInitialNodes).to.be.calledOnce

    it 'activates initial viewNodes', ->
      expect(@treeManager.activateInitialNodes).to.be.calledOnce


  describe 'Tree building behavior', ->
    beforeEach ->
      @$els = $render('nodes_with_data_view')

      $('body').empty()
      $('body').append(@$els)

    describe '.setInitialNodes', ->
      it 'creates list of elements for specified "app" and "view" selectors and initializes viewNodes for them', ->
        sinon.spy(@treeManager, 'ViewNode')
        @treeManager.setInitialNodes()
        expect(@treeManager.ViewNode.callCount).to.be.eql 4

      it 'has viewNodes pointed to corresponding dom elements in @initialNodes list', ->
        $els = $('body').find(@treeManager.viewSelector())
        expectedElsArray = $els.toArray()

        @treeManager.setInitialNodes()
        initialNodesEls = @treeManager.initialNodes.map('el')
        expect(initialNodesEls).to.be.eql expectedElsArray

      it 'saves viewNodes to NodesCache', ->
        sinon.spy(@treeManager.nodesCache, 'add')
        @treeManager.setInitialNodes()
        expect(@treeManager.nodesCache.add.callCount).to.be.eql 4

    describe '.setParentsForInitialNodes', ->
      it 'sets parents for initial nodes', ->
        @treeManager.setInitialNodes()
        initialNodes = @treeManager.initialNodes

        @treeManager.setParentsForInitialNodes()
        expect(@treeManager.setParentsForNodes).to.be.calledOnce
        expect(@treeManager.setParentsForNodes.lastCall.args[0]).to.be.equal initialNodes

    describe '.setChildrenForInitialNodes', ->
      it 'sets children for initial nodes', ->
        @treeManager.setInitialNodes()
        initialNodes = @treeManager.initialNodes

        @treeManager.setChildrenForInitialNodes()
        expect(@treeManager.setChildrenForNodes).to.be.calledOnce
        expect(@treeManager.setChildrenForNodes.lastCall.args[0]).to.be.equal initialNodes

    describe '.setParentsForNodes', ->
      beforeEach ->
        @treeManager.setInitialNodes()
        nodes = @treeManager.initialNodes

        $app = $('#app1')
        $view1 = $('#view1')
        $view2 = $('#view2')
        $view3 = $('#view3')

        appNodeId = $app.data('view-node-id')
        view1NodeId = $view1.data('view-node-id')
        view2NodeId = $view2.data('view-node-id')
        view3NodeId = $view3.data('view-node-id')

        @appNode   = @treeManager.nodesCache.getById(appNodeId)
        @view1Node = @treeManager.nodesCache.getById(view1NodeId)
        @view2Node = @treeManager.nodesCache.getById(view2NodeId)
        @view3Node = @treeManager.nodesCache.getById(view3NodeId)

        @treeManager.setParentsForNodes(nodes)

      it 'looks for closest view dom element and sets it as parent for provided viewNodes', ->
        expect(@view1Node.parent).to.be.equal @appNode
        expect(@view2Node.parent).to.be.equal @appNode
        expect(@view3Node.parent).to.be.equal @view2Node

      it 'sets null reference to node parent if have no parent', ->
        expect(@appNode.parent).to.be.null

      it 'adds node to cache as root if have no parent', ->
        expect(@treeManager.nodesCache.showRootNodes()).to.be.eql [@appNode]
