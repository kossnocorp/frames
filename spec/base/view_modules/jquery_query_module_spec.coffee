View = require('frames/view')
JqueryQuery = require('frames/jquery_query_module')

describe 'Frames.JqueryQuery', ->

  beforeEach ->
    class TestView extends View
      els: $user: '@user', $items: 'cached @item'
    TestView.include(JqueryQuery)
    @view = new TestView(el: document.body)
    @spy = sinon.stub(@view, '$', -> 42)

  afterEach ->
    @spy.restore()

  it 'creates query functions', ->
    @view.$user.should.be.a 'function'
    @view.$items.should.be.a 'function'

  it 'creates functions which queries elements with jQuery', ->
    @view.$user()
    @spy.should.be.calledWith('@user')

  it 'creates functions which queries elements with @el as context', ->
    @view.$user()
    @spy.should.be.calledWith('@user')

  describe 'when selector has "cached" prefix', ->

    it 'creates functions which queries elements with jQuery just once', ->
      @view.$items()
      @view.$items()
      @view.$items()
      @spy.should.be.calledWith('@item')
      @spy.should.be.calledOnce

    it 'creates function which drops cached value', ->
      @view.__$items = 666
      @view.$items().should.be.eq 666
      @view.$itemsDrop()
      @view.$items().should.be.eq 42
