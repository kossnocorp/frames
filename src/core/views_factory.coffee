Frames = window.Frames or require('framework')
Class = window.Frames?.Class or require('framework/class')

class ViewsFactory extends Class

  VIEWS_SELECTOR = '[data-view]'
  ROOT_SELECTOR = 'body'
  VIEW_NAME_SPLITTER = /\s/
  VIEW_PATH_WITH_COMPONENT_PATTERN = /(.+)#(.+)/

  @create: ($el = $(ROOT_SELECTOR), withRoot = true) ->
    @$viewEls($el, withRoot).each (index, el) =>
      @createViewsForEl($(el))

  @createViewsForEl: (el) ->
    $el = $(el)
    $el.data('created-views', {}) unless $el.data('created-views')

    viewPaths = $el.data('view').split(VIEW_NAME_SPLITTER)

    for originViewPath in viewPaths
      viewPath = @expandViewPath(originViewPath)
      unless $el.data('created-views')[viewPath]
        view = @initializeView(viewPath, el: $el)
        $el.data('created-views')[viewPath] = view

  @destroy: ($el = $(ROOT_SELECTOR), withRoot = true) ->
    @$viewEls($el, withRoot).each (index, el) =>
      @destroyViewsForEl($(el))

  @destroyViewsForEl: (el) ->
    $el = $(el)
    if createdViews = $el.data('created-views')
      for viewName, view of createdViews
        view.remove()
      $el.removeData('created-views')

  @expandViewPath: (viewPath) ->
    if VIEW_PATH_WITH_COMPONENT_PATTERN.test(viewPath)
      viewPath
    else
      'shared#' + viewPath

  @initializeView: (viewPath, options) ->
    ViewClass = @getViewClass(viewPath)
    new ViewClass(options) if ViewClass

  @getViewClass: (viewPath) ->
    [__, componentName, viewName] = viewPath.match(VIEW_PATH_WITH_COMPONENT_PATTERN)
    componentClassName = @getComponentClassName(componentName)
    viewClassName = @getViewClassName(viewName)

    ComponentClass = window[componentClassName]
    ViewClass if ComponentClass and ViewClass = ComponentClass[viewClassName]

  @getComponentClassName: (componentName) ->
    componentName.camelize() + 'Component' if componentName

  @getViewClassName: (viewName) ->
    viewName.camelize() + 'View' if viewName if viewName

  @$viewEls: ($el, withRoot = true) ->
    $els = $el.find(VIEWS_SELECTOR)
    if withRoot
      $els.add($el.filter(VIEWS_SELECTOR))
    else
      $els

Frames.registerFactory(ViewsFactory, 'views')

Frames.export('framework/views_factory', ViewsFactory)
