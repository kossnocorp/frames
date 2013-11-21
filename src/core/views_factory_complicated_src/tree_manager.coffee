Frames = require('framework')
Class = require('framework/class')
ViewFactory = require('views_factory_complicated')
NodesCache = require('views_factory_complicated/nodes_cache')

class TreeManager extends Class

  @options: ViewFactory.options

  @createTree: ->
    # TODO: add ability to set order for library sources
    # (I haven't find a way of doing this)
    @ViewNode = require('views_factory_complicated/view_node')

    @ViewNode.onInit @addViewNodeIdToElData.bind(@)

    @initNodes()
    @setParentsForInitialNodes()
    @setChildrenForInitialNodes()
    @activateNodes()

  @initNodes: ->
    $layouts = $(@options.appSelector)
    $views = $(@options.viewSelector)
    $els = $layouts.add($views)

    # contains links to all initial nodes
    @initialNodes = []

    for i in [0...$els.length]
      node = new @ViewNode($els.eq(i))
      NodesCache.add(node)

      @initialNodes.push(node)

  @setParentsForInitialNodes: ->
    @setParentsForNodes(@initialNodes)

  @setChildrenForInitialNodes: ->
    @setChildrenForNodes(@initialNodes)

  @setParentsForNodes: (nodes) ->
    for node in nodes
      $parentEl = node.$el.parent().closest(@viewSelector())

      # element has no parent if not found (i.e. it is root element)
      if $parentEl.length is 0
        NodesCache.addAsRoot(node)
      else
        # getting access to element viewNode through cache
        nodeId = $parentEl.data('view-node-id')
        node.parent = NodesCache.getById(nodeId)


  @setChildrenForNodes: (nodes) ->

  @activateNodes: ->

  @viewSelector: ->
    @_viewSelector ||= "#{@options.appSelector}, #{@options.viewSelector}"

  @addViewNodeIdToElData: (viewNode) ->
    viewNode.$el.data('view-node-id', viewNode.id)

Frames.export('views_factory_complicated/tree_manager', TreeManager)
