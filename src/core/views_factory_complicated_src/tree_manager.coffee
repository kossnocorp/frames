Frames = require('framework')
Class = require('framework/class')
ViewFactory = require('views_factory_complicated')
NodesCache = require('views_factory_complicated/nodes_cache')

class TreeManager extends Class

  constructor: ->
    @options = ViewFactory.options

    # TODO: add ability to set order for library sources
    # (I haven't find a way of doing this)
    @ViewNode = require('views_factory_complicated/view_node')
    @initViewHooks()

    @initialNodes = []
    @nodesCache = new NodesCache()

  initViewHooks: ->
    ViewHooks = require('views_factory_complicated/view_hooks')
    @viewHooks = new ViewHooks
    @viewHooks.onInit @addViewNodeIdToElData.bind(@)

  createTree: ->
    @setInitialNodes()
    @setParentsForInitialNodes()
    @setChildrenForInitialNodes()
    @activateInitialNodes()

  setInitialNodes: ->
    $els = $(@viewSelector())

    @initialNodes = []

    for i in [0...$els.length]
      node = new @ViewNode($els.eq(i), @viewHooks)
      @nodesCache.add(node)
      @initialNodes.push(node)

  setParentsForInitialNodes: ->
    @setParentsForNodes(@initialNodes)

  setChildrenForInitialNodes: ->
    @setChildrenForNodes(@initialNodes)

  setParentsForNodes: (nodes) ->
    for node in nodes
      $parentEl = node.$el.parent().closest(@viewSelector())

      # element has no parent if not found (i.e. it is root element)
      if $parentEl.length is 0
        @nodesCache.addAsRoot(node)
      else
        # getting access to element viewNode through cache
        nodeId = $parentEl.data('view-node-id')
        node.parent = @nodesCache.getById(nodeId)

  setChildrenForNodes: (nodes) ->
    return unless nodes.length

    node = nodes.shift()

    # setting child nodes for first node in list
    node.setChildren(nodes)

    # setting child nodes for remaining nodes
    @setChildrenForNodes(nodes)

  activateInitialNodes: ->
    @activateRootNodes(@initialNodes)

  activateRootNodes: (nodes) ->
    rootNodes = @nodesCache.showRootNodes()

    for node in rootNodes
      @activateNode(node)

  activateNode: (node) ->
    node.activate()

    for childNode in node.children
      @activateNode(childNode)

  viewSelector: ->
    @_viewSelector ||= "#{@options.appSelector}, #{@options.viewSelector}"

  addViewNodeIdToElData: (viewNode) ->
    viewNode.$el.data('view-node-id', viewNode.id)

Frames.export('views_factory_complicated/tree_manager', TreeManager)
