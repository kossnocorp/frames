RoutersFactory = require('framework/routers_factory')

describe 'RoutersFactory', ->

  $render = (name) ->
    $(window.__html__["spec/fixtures/#{name}.html"])

  $renderToBody = (name) ->
    $('body').append($render(name))

  beforeEach ->
    $('body').empty()
    Backbone.History.started = false

  describe '.create', ->

    it 'creates first router found on the page', ->
      window.MainRouter = sinon.spy()
      $renderToBody('nodes_with_single_router')
      RoutersFactory.create()
      expect(MainRouter).to.be.called
      delete window.MainRouter

    it 'stores router ref in body data', ->
      window.MainRouter = sinon.spy()
      $renderToBody('nodes_with_single_router')
      RoutersFactory.create()
      expect($('body').data('router')).to.be.instanceOf window.MainRouter
      delete window.MainRouter

    it "doesn't throw error if router is not found", ->
      $renderToBody('nodes_without_router')
      RoutersFactory.create()

    it "doesn't throw error if router is not defined on the page", ->
      RoutersFactory.create()

    it 'starts Backbone.history if router is detected', ->
      window.MainRouter = sinon.spy()
      spy = sinon.spy(Backbone.history, 'start')
      $renderToBody('nodes_with_single_router')
      RoutersFactory.create()
      expect(spy).to.be.called
      delete window.MainRouter

  describe '.destroy', ->

    it 'remove ref to current router', ->
      window.MainRouter = sinon.spy()
      $renderToBody('nodes_with_single_router')
      RoutersFactory.create()
      RoutersFactory.destroy()
      expect($('body').data('router')).to.not.exist
      delete window.MainRouter

    it "doesn't throw error if router is not initialized", ->
      RoutersFactory.destroy()

    it 'stops Backbone.history', ->
      spy = sinon.spy(Backbone.history, 'stop')
      RoutersFactory.destroy()
      expect(spy).to.be.called

  describe '.detectRouter', ->

    it 'find router by first found data-router', ->
      $renderToBody('nodes_with_single_router')
      expect(RoutersFactory.detectRouter()).to.be.eq 'main'

    it 'inform when there are more than one router on same page', ->
      $renderToBody('nodes_with_few_routers')
      warnSpy = sinon.spy(RoutersFactory, 'warn')
      expect(RoutersFactory.detectRouter()).to.be.eq 'first'
      expect(warnSpy).to.be.calledWith('There are more than one router, all except first will be ignored.')

  describe '.routers', ->

    it 'it returns all els with data-router', ->
      $renderToBody('nodes_with_few_routers')

      expect(RoutersFactory.routers()).to.be.eql ['first', 'second']

