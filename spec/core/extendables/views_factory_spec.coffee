Frames = modula.require 'frames'
ViewsFactory = modula.require 'frames/views_factory'

describe 'Frames.Extendables.ViewsFactory', ->
  before ->
    sinon.spy(ViewsFactory, 'create')

  beforeEach ->
    @extendable = new Frames.Extendables.ViewsFactory()

  after ->
    ViewsFactory.create.restore()

  context 'module is not extended', ->
    it 'uses default views factory by default', ->
      expect(ViewsFactory.create).to.be.not.called
      @extendable.ready()
      expect(ViewsFactory.create).to.be.called

  context 'module is extended', ->
    it 'uses extended views factory', ->
      NewViewsFactory = {create: sinon.spy()}
      @extendable.extended(NewViewsFactory)
      @extendable.ready()
      expect(NewViewsFactory.create).to.be.called
