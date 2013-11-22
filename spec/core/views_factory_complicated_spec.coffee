ViewsFactory = require('views_factory_complicated')

describe 'ViewsFactory', ->

  describe '.initRemoveEvent', ->
    it 'creates custom jquery event, which being triggered when element being removed from DOM', ->
      ViewsFactory.initRemoveEvent()
      fnSpy = sinon.spy()
      $el = $('<div />')
      $el2 = $('<div />')

      $('body').append($el).append($el2)
      $el.on('remove', fnSpy)
      $el2.on('remove', fnSpy)
      $el.remove()
      $el2.remove()

      expect(fnSpy).to.be.calledTwice

  describe '.create', ->
    it 'initializes custom jquery remove event', ->
      sinon.spy(ViewsFactory, 'initRemoveEvent')
      ViewsFactory.create()
      expect(ViewsFactory.initRemoveEvent).to.be.calledOnce

    it 'initializes custom jquery refresh event', ->
      sinon.spy(ViewsFactory, 'initRefreshEvent')
      ViewsFactory.create()
      expect(ViewsFactory.initRefreshEvent).to.be.calledOnce
