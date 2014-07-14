Frames = modula.require('frames')
Class = modula.require('frames/class')
Backbone = window.Backbone

class RoutersFactory extends Class

  ROUTERS_SELECTOR = '[data-router]'

  @create: ->
    routerName = @detectRouter()
    if routerName
      routerClassName = routerName.camelize() + 'Router'
      Router = window[routerClassName]
      if Router
        router = new Router()
        $('body').data {router}
        Backbone.history.start()
        @router = router

  @destroy: ->
    $('body').removeData('router')
    Backbone.history.stop()

  @detectRouter: ->
    routers = @routers()
    if routers.length > 1
      @warn('There are more than one router, all except first will be ignored.')
    routers[0]

  @routers: ->
    $root = $('body')
    $els = $root.find(ROUTERS_SELECTOR).add($root.filter(ROUTERS_SELECTOR))
    $els.map(-> $(@).data('router')).toArray()

Frames.registerFactory(RoutersFactory, 'routers')

modula.export('frames/routers_factory', RoutersFactory)
