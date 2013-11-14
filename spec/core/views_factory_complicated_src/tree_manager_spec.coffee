TreeManager = require('views_factory_complicated/tree_manager')

describe 'TreeManager', ->

  describe '.create', ->

    it 'returns true', ->
      expect(TreeManager.create()).to.be.true
