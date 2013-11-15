Frames = require('framework')
Class = require('framework/class')
ViewFactory = require('views_factory_complicated')

class ViewNode extends Class

  viewNodeId = 1

  constructor: ($el) ->
    @options = ViewFactory.options

    @$el = $el
    @el = $el[0]
    @id = "viewNodeId#{viewNodeId}"

    viewNodeId++

Frames.export('views_factory_complicated/view_node', ViewNode)
