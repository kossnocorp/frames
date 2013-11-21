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

  @setChildrenForNodes: (nodes) ->

  @activateNodes: ->

  @addViewNodeIdToElData: (viewNode) ->
    viewNode.$el.data('view-node-id', viewNode.id)

Frames.export('views_factory_complicated/tree_manager', TreeManager)
