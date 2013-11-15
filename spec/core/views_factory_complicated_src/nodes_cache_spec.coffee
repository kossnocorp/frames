NodesCache = require('views_factory_complicated/nodes_cache')

describe 'NodesCache', ->

  describe 'Describe initial state of cache', ->

    describe '.show', ->
      it 'returns empty hash by default', ->
        nodesHash = NodesCache.show()
        expect(nodesHash).to.be.an('object')
        expect(nodesHash).to.be.eql {}

    describe '.showRootNodes', ->
      it 'returns empty list by default', ->
        rootNodesList = NodesCache.showRootNodes()
        expect(rootNodesList).to.be.an('array')
        expect(rootNodesList).to.be.eql []

  describe 'Cache management actions', ->

    beforeEach ->
      NodesCache.clear()
      @node = id: 1, whatever: 'content'
      @secondNode = id: 2, whatever: 'more content'

    describe '.add', ->
      it 'adds node to nodes hash', ->
        NodesCache.add(@node)
        expect(NodesCache.show()).to.be.eql {1: @node}

        NodesCache.add(@secondNode)
        expect(NodesCache.show()).to.be.eql {1: @node, 2: @secondNode}

    describe '.addAsRoot', ->
      it 'adds node to root nodes list', ->
        NodesCache.addAsRoot(@node)
        expect(NodesCache.showRootNodes()).to.be.eql [@node]

        NodesCache.addAsRoot(@secondNode)
        expect(NodesCache.showRootNodes()).to.be.eql [@node, @secondNode]

    describe '.getById', ->
      it "returns node by it's index", ->
        NodesCache.add(@node)

        returnedNode = NodesCache.getById(@node.id)
        expect(returnedNode).to.be.equal @node

    describe '.removeById', ->
      it 'removes node from nodes hash by provided id', ->
        NodesCache.add(@node)
        NodesCache.add(@secondNode)
        NodesCache.removeById(2)

        nodesHash = NodesCache.show()
        expect(nodesHash).to.be.eql {1: @node}

      it 'removes node from root nodes list by provided id', ->
        NodesCache.addAsRoot(@node)
        NodesCache.addAsRoot(@secondNode)
        NodesCache.removeById(1)

        rootNodesList = NodesCache.showRootNodes()
        expect(rootNodesList).to.be.eql [@secondNode]

    describe '.clear', ->
      it 'clears nodes hash', ->
        NodesCache.add(@node)
        NodesCache.add(@secondNode)
        NodesCache.clear()

        nodesHash = NodesCache.show()
        expect(nodesHash).to.be.an('object')
        expect(nodesHash).to.be.eql {}

      it 'clears root nodes list', ->
        NodesCache.addAsRoot(@node)
        NodesCache.addAsRoot(@secondNode)
        NodesCache.clear()

        rootNodesList = NodesCache.showRootNodes()
        expect(rootNodesList).to.be.an('array')
        expect(rootNodesList).to.be.eql []
