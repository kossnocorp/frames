ViewNode = require('views_factory_complicated/view_node')
TreeManager = require('views_factory_complicated/tree_manager')
ViewWrapper = require('views_factory_complicated/view_wrapper')

describe 'ViewWrapper', ->

  $render = (name) ->
    $(window.__html__["spec/fixtures/complicated_views/#{name}.html"])

  describe '.constructor', ->
    beforeEach ->
      @$el = $('<div />')
      @viewNode = new ViewNode(@$el)
      @viewWrapper = new ViewWrapper(@viewNode)

    it 'saves reference to provided view node in @viewNode', ->
      expect(@viewWrapper.viewNode).to.be.equal @viewNode

    it 'saves reference to viewNode.$el in @$el', ->
      expect(@viewWrapper.$el).to.be.equal @viewNode.$el

    it 'saves reference to viewNode.el in @el', ->
      expect(@viewWrapper.el).to.be.equal @viewNode.el

    it 'identifies view', ->
      sinon.spy(ViewWrapper::, 'identifyView')
      viewNode = new ViewNode(@$el)
      viewWrapper = new ViewWrapper(viewNode)
      expect(viewWrapper.identifyView).to.be.calledOnce

    it 'initializes view', ->
      sinon.spy(ViewWrapper::, 'initView')
      viewNode = new ViewNode(@$el)
      viewWrapper = new ViewWrapper(viewNode)
      expect(viewWrapper.initView).to.be.calledOnce

  describe 'View initialization', ->
    before ->
      window.TestAppComponent =
        LayoutView: sinon.spy()
        TestView1View: sinon.spy()
        TestView2View: sinon.spy()
        TestView3View: sinon.spy()
        TestView4View: sinon.spy()
        TestView5View: sinon.spy()
        TestView6View: sinon.spy()
      window.TestApp2Component =
        LayoutView: sinon.spy()
        TestView8View: sinon.spy()
      window.TestComponentComponent =
        TestView7View: sinon.spy()
        TestView9View: sinon.spy()

    beforeEach ->
      $els = $render('nodes_with_data_view')
      $newEls = $render('nodes_for_refresh')
      treeManager = new TreeManager

      $('body').empty().append($els)
      $('#app1').append($newEls)

      treeManager.setInitialNodes()
      treeManager.setParentsForInitialNodes()
      treeManager.setChildrenForInitialNodes()

      appNodeId = $('#app1').data('view-node-id')
      @appNode = treeManager.nodesCache.getById(appNodeId)
      @appNode.activate()

      # order matters here
      for el in 'view1 view2 view3 view4 view5 view6 view7 app2 view8 view9'.split(' ')
        id = $('#' + el).data('view-node-id')
        @[el + 'Node'] = treeManager.nodesCache.getById(id)
        @[el + 'Node'].activate()

    describe '.initView', ->
      sharedViewConstructors = ->
        expect(TestAppComponent.LayoutView).to.be.calledOnce
        expect(TestAppComponent.TestView1View).to.be.calledOnce
        expect(TestAppComponent.TestView2View).to.be.calledOnce
        expect(TestAppComponent.TestView3View).to.be.calledOnce
        expect(TestAppComponent.TestView4View).to.be.calledOnce
        expect(TestAppComponent.TestView5View).to.be.calledOnce
        expect(TestAppComponent.TestView6View).to.be.calledOnce

        expect(TestApp2Component.LayoutView).to.be.calledOnce
        expect(TestApp2Component.TestView8View).to.be.calledOnce

        expect(TestComponentComponent.TestView7View).to.be.calledOnce
        expect(TestComponentComponent.TestView9View).to.be.calledOnce

      it 'should initialize view depending on component and name', ->
        sharedViewConstructors.call(@)

    describe '.isLayout', ->
      it 'checks if viewNode should initialize a layout view', ->
        expect(@appNode.viewWrapper.isLayout()).to.be.true
        expect(@view1Node.viewWrapper.isLayout()).to.be.false
        expect(@view2Node.viewWrapper.isLayout()).to.be.false
        expect(@view3Node.viewWrapper.isLayout()).to.be.false
        expect(@view4Node.viewWrapper.isLayout()).to.be.false
        expect(@view5Node.viewWrapper.isLayout()).to.be.false
        expect(@view6Node.viewWrapper.isLayout()).to.be.false
        expect(@view7Node.viewWrapper.isLayout()).to.be.false
        expect(@app2Node.viewWrapper.isLayout()).to.be.true
        expect(@view8Node.viewWrapper.isLayout()).to.be.false
        expect(@view9Node.viewWrapper.isLayout()).to.be.false

    describe '.hasComponent', ->
      it 'checks if component name is specified manually', ->
        expect(@appNode.viewWrapper.hasComponent()).to.be.false
        expect(@view1Node.viewWrapper.hasComponent()).to.be.false
        expect(@view2Node.viewWrapper.hasComponent()).to.be.false
        expect(@view3Node.viewWrapper.hasComponent()).to.be.false
        expect(@view4Node.viewWrapper.hasComponent()).to.be.false
        expect(@view5Node.viewWrapper.hasComponent()).to.be.false
        expect(@view6Node.viewWrapper.hasComponent()).to.be.false
        expect(@view7Node.viewWrapper.hasComponent()).to.be.true
        expect(@app2Node.viewWrapper.hasComponent()).to.be.false
        expect(@view8Node.viewWrapper.hasComponent()).to.be.false
        expect(@view9Node.viewWrapper.hasComponent()).to.be.true

    describe '.identifyView', ->
      it 'identifies current view layout name', ->
        expect(@appNode.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view1Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view2Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view3Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view4Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view5Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view6Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@view7Node.viewWrapper.layoutName).to.be.eql 'test_app'
        expect(@app2Node.viewWrapper.layoutName).to.be.eql 'test_app2'
        expect(@view8Node.viewWrapper.layoutName).to.be.eql 'test_app2'
        expect(@view9Node.viewWrapper.layoutName).to.be.eql 'test_app2'

      it 'identifies current view layout id', ->
        app1LayoutId = @appNode.viewWrapper.layoutId
        expect(@appNode.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view1Node.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view2Node.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view3Node.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view4Node.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view5Node.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view6Node.viewWrapper.layoutId).to.be.eql app1LayoutId
        expect(@view7Node.viewWrapper.layoutId).to.be.eql app1LayoutId

        app2LayoutId = @app2Node.viewWrapper.layoutId
        expect(@app2Node.viewWrapper.layoutId).to.be.eql app2LayoutId
        expect(@view8Node.viewWrapper.layoutId).to.be.eql app2LayoutId
        expect(@view9Node.viewWrapper.layoutId).to.be.eql app2LayoutId

      it 'identifies current view component name', ->
        expect(@appNode.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view1Node.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view2Node.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view3Node.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view4Node.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view5Node.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view6Node.viewWrapper.componentName).to.be.eql 'test_app'
        expect(@view7Node.viewWrapper.componentName).to.be.eql 'test_component'
        expect(@app2Node.viewWrapper.componentName).to.be.eql 'test_app2'
        expect(@view8Node.viewWrapper.componentName).to.be.eql 'test_app2'
        expect(@view9Node.viewWrapper.componentName).to.be.eql 'test_component'

      it 'identifies current view class name', ->
        expect(@appNode.viewWrapper.viewClassName).to.be.eql 'LayoutView'
        expect(@view1Node.viewWrapper.viewClassName).to.be.eql 'TestView1View'
        expect(@view2Node.viewWrapper.viewClassName).to.be.eql 'TestView2View'
        expect(@view3Node.viewWrapper.viewClassName).to.be.eql 'TestView3View'
        expect(@view4Node.viewWrapper.viewClassName).to.be.eql 'TestView4View'
        expect(@view5Node.viewWrapper.viewClassName).to.be.eql 'TestView5View'
        expect(@view6Node.viewWrapper.viewClassName).to.be.eql 'TestView6View'
        expect(@view7Node.viewWrapper.viewClassName).to.be.eql 'TestView7View'
        expect(@app2Node.viewWrapper.viewClassName).to.be.eql 'LayoutView'
        expect(@view8Node.viewWrapper.viewClassName).to.be.eql 'TestView8View'
        expect(@view9Node.viewWrapper.viewClassName).to.be.eql 'TestView9View'

      it 'identifies current view component name', ->
        expect(@appNode.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view1Node.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view2Node.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view3Node.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view4Node.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view5Node.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view6Node.viewWrapper.componentClassName).to.be.eql 'TestAppComponent'
        expect(@view7Node.viewWrapper.componentClassName).to.be.eql 'TestComponentComponent'
        expect(@app2Node.viewWrapper.componentClassName).to.be.eql 'TestApp2Component'
        expect(@view8Node.viewWrapper.componentClassName).to.be.eql 'TestApp2Component'
        expect(@view9Node.viewWrapper.componentClassName).to.be.eql 'TestComponentComponent'
