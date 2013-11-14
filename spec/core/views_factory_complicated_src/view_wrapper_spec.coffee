ViewWrapper = require('views_factory_complicated/view_wrapper')

describe 'ViewWrapper', ->

  describe '.create', ->

    it 'returns true', ->
      expect(ViewWrapper.create()).to.be.true
