# TODO: at this moment complicated views factory only works with Modula,
# export to window is not supported

Frames = require('framework')
Class = require('framework/class')

class ViewsFactory extends Class

  VIEW_SELECTOR = '[data-view]'
  APP_SELECTOR = '[data-app]'

  @options:
    viewSelector: VIEW_SELECTOR
    appSelector: APP_SELECTOR

  @create: ->
    true

Frames.registerFactory(ViewsFactory, 'views')

Frames.export('views_factory_complicated', ViewsFactory)
