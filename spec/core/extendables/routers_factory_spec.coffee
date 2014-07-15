Frames = modula.require 'frames'
RoutersFactory = modula.require 'frames/routers_factory'

describe 'Frames.Extendables.RoutersFactory', ->
  before ->
    sinon.spy(RoutersFactory, 'create')

  beforeEach ->
    @extendable = new Frames.Extendables.RoutersFactory()

  after ->
    RoutersFactory.create.restore()

  context 'module is not extended', ->
    it 'uses default routers factory by default', ->
      expect(RoutersFactory.create).to.be.not.called
      @extendable.ready()
      expect(RoutersFactory.create).to.be.called

  context 'module is extended', ->
    it 'uses extended routers factory', ->
      NewRoutersFactory = {create: sinon.spy()}
      @extendable.extended(NewRoutersFactory)
      @extendable.ready()
      expect(NewRoutersFactory.create).to.be.called
