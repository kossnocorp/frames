NodesCache = require('views_factory_complicated/nodes_cache')

describe 'NodesCache', ->

  describe '.create', ->

    it 'returns true', ->
      expect(NodesCache.create()).to.be.true
