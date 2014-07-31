Frames = modula.require 'frames'

describe 'Frames.Extendables.ViewsFactory', ->

  beforeEach ->
    @extendable = new Frames.Extendables.ViewsFactory()

  context 'module is not extended', ->
    it 'uses default views factory by default', ->
      ViewsFactory = @extendable.viewsFactory

      sinon.spy(ViewsFactory, 'create')
      expect(ViewsFactory.create).to.be.not.called
      @extendable.ready()
      expect(ViewsFactory.create).to.be.called

  context 'module is extended', ->
    it 'uses extended views factory', ->
      NewViewsFactory = {create: sinon.spy()}
      @extendable.extended(NewViewsFactory)
      @extendable.ready()
      expect(NewViewsFactory.create).to.be.called
