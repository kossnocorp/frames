ViewNode = require('views_factory_complicated/view_node')

describe 'ViewNode', ->

  describe '.create', ->

    it 'returns true', ->
      expect(ViewNode.create()).to.be.true
