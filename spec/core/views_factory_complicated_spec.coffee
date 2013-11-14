ViewsFactory = require('views_factory_complicated')

describe 'ViewsFactory', ->

  describe '.create', ->

    it 'returns true', ->
      expect(ViewsFactory.create()).to.be.true
