Frames = require('framework')
Class = require('framework/class')
ViewFactory = require('views_factory_complicated')

class ViewNode extends Class

  _onInitCallbacks = []
  _onActivationCallbacks = []
  _onUnloadCallbacks = []

  viewNodeId = 1

  @onInit: (callback) ->
    callbacksList = _onInitCallbacks
    callbacksList.push(callback)

  @clearInitCallbacks: ->
    _onInitCallbacks = []

  @onActivation: (callback) ->
    callbacksList = _onActivationCallbacks
    callbacksList.push(callback)

  @onUnload: (callback) ->
    callbacksList = _onUnloadCallbacks
    callbacksList.push(callback)

  constructor: ($el) ->
    @options = ViewFactory.options

    @$el = $el
    @el = $el[0]
    @id = "viewNodeId#{viewNodeId}"
    @parent = null
    @children = []

    viewNodeId++

    @init()

  setParent: (viewNode) ->
    @parent = viewNode

  setChildren: (viewNodes) ->
    @children = _.filter(viewNodes, (node) =>
      node.parent and node.parent.el is @el
    )

  removeChild: (viewNode) ->
    return if _.indexOf(@children, viewNode) is -1
    @children = _.reject(@children, (childNode) -> childNode is viewNode)

  init: ->
    callback(@) for callback in @onInitCallbacks()

  activate: ->
    return if @isActivated()

    @setAsActivated()
    callback(@) for callback in @onActivationCallbacks()

  remove: ->
    return if @isRemoved()

    @setAsRemoved()
    if @isActivated()
      @unload()

  unload: ->
    callback(@) for callback in @onUnloadCallbacks()
    @setAsNotActivated()


  # private

  setAsActivated: ->
    @_isActivated = true

  setAsNotActivated: ->
    @_isActivated = false

  isActivated: ->
    @_isActivated ||= false

  setAsRemoved: ->
    @_isRemoved = true

  isRemoved: ->
    @_isRemoved ||= false

  onInitCallbacks: ->
    _onInitCallbacks

  onActivationCallbacks: ->
    _onActivationCallbacks

  onUnloadCallbacks: ->
    _onUnloadCallbacks

Frames.export('views_factory_complicated/view_node', ViewNode)
