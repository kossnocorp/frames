# TODO: at this moment complicated views factory only works with Modula,
# export to window is not supported

Frames = require('framework')
Class = require('framework/class')

class ViewsFactory extends Class

  @create: ->
    true

Frames.registerFactory(ViewsFactory, 'views')

Frames.export('views_factory_complicated', ViewsFactory)
