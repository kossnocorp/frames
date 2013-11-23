Frames = require('framework')
Class = require('framework/class')

class ViewWrapper extends Class

  layoutId = 0
  COMPONENT_PATTERN = /(.+)#(.+)/
  SECRET_KEY = 'semarf'

  constructor: (@viewNode) ->
    @$el = @viewNode.$el
    @el = @viewNode.el

    layoutId++ if @isLayout()
    @identifyView()
    @initView()

  identifyView: ->
    @layoutName = @layout().name
    @layoutId = @layout().id

    if @hasComponent()
      [__, @componentName, @viewName] = @viewDataValue().match(COMPONENT_PATTERN)
    else
      [@componentName, @viewName] = [@layoutName, @viewDataValue()]

    @componentClassName = @componentName.camelize() + 'Component'
    @viewClassName = @viewName.camelize() + 'View'

  initView: ->
    viewName = "#{@componentClassName}.#{@viewClassName}"

    if ViewConstructor = window[@componentClassName]?[@viewClassName]
      @viewInstance = new ViewConstructor
        el: @el
        viewClassName: @viewClassName
        viewFullName: @viewName
        layoutId: @layoutId

    else
      # TODO: 'show errors'
      # Core.warn "Can find view class for '#{viewName}'"

  isLayout: ->
    @_isLayout ||= @$el.data('app')?

  viewDataValue: ->
    @_viewDataValue ||=
      if not @isLayout()
        @$el.data('view') || SECRET_KEY
      else
        'layout'

  hasComponent: ->
    @_hasComponent ||= COMPONENT_PATTERN.test(@viewDataValue())

  layout: ->
    @_layout ||=
      if @isLayout()
        {name: @$el.data('app'), id: layoutId}
      else if @viewNode.parent?
        @viewNode.parent.viewWrapper.layout()
      else
        {name: SECRET_KEY, id: 0}

  unload: ->

Frames.export('views_factory_complicated/view_wrapper', ViewWrapper)
