ViewsFactory = require('frames/views_factory')

describe 'ViewsFactory', ->

  $render = (name) ->
    $(window.__html__["spec/fixtures/#{name}.html"])

  beforeEach ->
    $('body').empty()

  describe '.create', ->

    beforeEach ->
      window.SharedComponent =
        TestView: sinon.spy()
      window.Test1Component =
        Test1View: sinon.spy()
      window.Test2Component =
        Test1View: sinon.spy()
        Test2View: sinon.spy()
      @$els = $render('nodes_with_data_view')

    sharedExamples = ->
      expect(SharedComponent.TestView).to.be.called
      expect(Test1Component.Test1View).to.be.called
      expect(Test2Component.Test1View).to.be.called
      expect(Test2Component.Test2View).to.be.called

    it 'creates views for nodes', ->
      ViewsFactory.create(@$els)
      sharedExamples.call(@)

    it 'creates views in body if el is not passed', ->
      $('body').append(@$els)
      ViewsFactory.create()
      sharedExamples.call(@)

    it 'creates views only for internal els if second arg is false', ->
      ViewsFactory.create(@$els, false)
      expect(SharedComponent.TestView).to.be.called
      expect(Test1Component.Test1View).to.not.be.called
      expect(Test2Component.Test1View).to.be.called
      expect(Test2Component.Test2View).to.be.called

  describe '.createViewsForEl', ->

    beforeEach ->
      @$el = $render('nodes_with_data_view').find('#4')
      window.Test2Component =
        Test1View: sinon.spy()
        Test2View: sinon.spy()

    it 'creates views for el', ->
      ViewsFactory.createViewsForEl(@$el)
      expect(Test2Component.Test1View).to.be.called
      expect(Test2Component.Test2View).to.be.called

    it 'saves references to data-views', ->
      obj1 = {}
      obj2 = {}
      Test2Component.Test1View = sinon.stub().returns(obj1)
      Test2Component.Test2View = sinon.stub().returns(obj2)
      ViewsFactory.createViewsForEl(@$el)
      expect(@$el.data('created-views')['test_2#test_1']).to.be.eq obj1
      expect(@$el.data('created-views')['test_2#test_2']).to.be.eq obj2

    it 'do not creates views for already initialized', ->
      ViewsFactory.createViewsForEl(@$el)
      ViewsFactory.createViewsForEl(@$el)
      expect(Test2Component.Test1View).to.be.calledOnce
      expect(Test2Component.Test2View).to.be.calledOnce

  describe 'destroy process', ->

    beforeEach ->
      @fakeViews = fakeViews = []
      class @FakeView
        constructor: ->
          fakeViews.push(@)
          @remove = sinon.spy()

    describe '.destroy', ->

      beforeEach ->
        window.SharedComponent =
          TestView: @FakeView
        window.Test1Component =
          Test1View: @FakeView
        window.Test2Component =
          Test1View: @FakeView
          Test2View: @FakeView
        @$els = $render('nodes_with_data_view')
        ViewsFactory.create(@$els)

      sharedExamples = ->
        for view in @fakeViews
          expect(view.remove).to.be.called

      it 'calls remove for every views in passed el', ->
        ViewsFactory.destroy(@$els)
        sharedExamples.apply(@)

      it 'removes views in body if el is not passed', ->
        @$els.appendTo('body')
        ViewsFactory.destroy()
        sharedExamples.apply(@)

      it 'removes views only for internal els if second arg is false', ->
        viewsMap = {}
        ViewsFactory.$viewEls(@$els).each ->
          $el = $(@)
          for viewName, view of $el.data('created-views')
            viewsMap[viewName] = view

        ViewsFactory.destroy(@$els, false)

        for viewName, view of viewsMap
          if viewName is 'test_1#test_1'
            expect(view.remove).to.not.be.called
          else
            expect(view.remove).to.be.called

    describe '.destroyViewsForEl', ->

      beforeEach ->
        window.Test2Component =
          Test1View: @FakeView
          Test2View: @FakeView
        @$el = $render('nodes_with_data_view').find('#4')
        ViewsFactory.create(@$el)

      it 'calls remove for views created for passed el', ->
        ViewsFactory.destroyViewsForEl(@$el)
        for view in @fakeViews
          expect(view.remove).to.be.called

      it 'clear data-views', ->
        ViewsFactory.destroyViewsForEl(@$el)
        should.not.exist @$el.data('created-views')

  describe '.expandViewPath', ->

    it 'returns origin path is component is specified', ->
      expect(ViewsFactory.expandViewPath('component_name#view_name')).to.be.eq 'component_name#view_name'

    it 'adds shared to view path if component is not defined', ->
      expect(ViewsFactory.expandViewPath('view_name')).to.be.eq 'shared#view_name'

  describe '.initializeView', ->

    it 'creates instance of view for passed view path', ->
      ViewClass = sinon.spy()
      window.SomeComponent = ViewNameView: ViewClass
      ViewsFactory.initializeView('some#view_name')
      expect(ViewClass).to.be.calledOnce

    it 'passes options to view constructor', ->
      ViewClass = sinon.spy()
      options = {}
      window.SomeComponent = ViewNameView: ViewClass
      ViewsFactory.initializeView('some#view_name', options)
      expect(ViewClass).to.be.calledWith(options)

    it 'do not throw exception for undefined view path', ->
      ViewsFactory.initializeView('incorrect#path')

    it 'returns view instance', ->
      obj = {}
      ViewClass = sinon.stub().returns(obj)
      window.SomeComponent = ViewNameView: ViewClass
      expect(ViewsFactory.initializeView('some#view_name')).to.be.eq obj

  describe '.getViewClass', ->

    it 'returns view class by component_name#view_name', ->
      ViewClass = {}
      window.ComponentNameComponent = ViewNameView: ViewClass
      expect(ViewsFactory.getViewClass('component_name#view_name')).to.be.eql ViewClass

    it 'returns null for not defined component or view', ->
      expect(ViewsFactory.getViewClass('not_defined_component#not_defined_view')).to.not.exist

  describe '.getComponentClassName', ->

    it 'returns ComponentNameComponent for component_name', ->
      expect(ViewsFactory.getComponentClassName('component_name')).to.be.eq 'ComponentNameComponent'

  describe '.getViewClassName', ->

    it 'returns ViewNameView for view_name', ->
      expect(ViewsFactory.getViewClassName('view_name')).to.be.eq 'ViewNameView'

  describe '.$viewEls', ->

    it 'returns jQuery collection of els with data-view attr', ->
      $els = ViewsFactory.$viewEls($render('nodes_with_data_view'))
      expect($els.length).to.be.eq 3

    it 'returns only internal views if seconds argument is false', ->
      $els = ViewsFactory.$viewEls($render('nodes_with_data_view'), false)
      expect($els.length).to.be.eq 2
