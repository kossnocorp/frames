ViewsFactory = require('views_factory_complicated')
ViewNode = require('views_factory_complicated/view_node')

describe 'ViewNode', ->

  beforeEach ->
    ViewsFactory.options = {viewSelector: 'some_strange_selector'}

    @$el = $('div')
    @$secondEl = $('div')
    @$thirdEl = $('div')

    @viewNode = new ViewNode(@$el)
    @secondViewNode = new ViewNode(@$secondEl)
    @thirdViewNode = new ViewNode(@$thirdEl)

  describe '.constructor', ->
    it 'shares options from base ViewsFactory class', ->
      expect(@viewNode.options).to.be.equal ViewsFactory.options

    it 'has uniq id', ->
      ids = [@viewNode.id, @secondViewNode.id, @thirdViewNode.id]
      expect(ids.unique()).to.have.length 3

    it 'has reference to provided jquery dom element', ->
      expect(@viewNode.$el).to.be.equal @$el
      expect(@viewNode.el).to.be.equal @$el[0]
