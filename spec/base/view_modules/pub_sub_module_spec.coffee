BaseView = modula.require('frames/view')
PubSubModule = modula.require('frames/pub_sub_module')

class View extends BaseView
  @include PubSubModule

describe 'Frames.PubSubModule', ->

  beforeEach ->
    @viewA = new View()
    @viewB = new View()
    @spy = sinon.spy()

  describe '#emit', ->

    it 'send notification to every view', ->
      @viewB.listen('message', @spy)
      @viewA.emit('message')
      @spy.should.be.called

  describe '#listen', ->

    it 'receives notification', ->
      @viewB.listen('message', @spy)
      @viewA.emit('message', 'Test of #listen')

      @spy.should.be.calledWithMatch \
        sinon.match('body': 'Test of #listen')

    it 'receives notification on current object', ->
      @viewB.listen('message', @spy)
      @viewA.emit('message', 'Test of #listen')

      @spy.should.be.calledOn(@viewB)

  describe '#unsubscribe', ->

    it 'stop listening of message', ->
      @viewB.listen('message', @spy)
      @viewB.unsubscribe('message')
      @viewA.emit('message')

      @spy.should.not.be.called
