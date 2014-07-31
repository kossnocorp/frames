Frames = modula.require 'frames'

class Frames.Extendables.ViewsFactory

  constructor: ->
    @viewsFactory =
      create: -> Vtree.initNodes()

  extended: (args...) ->
    [viewsFactory] = args
    @viewsFactory = viewsFactory

  ready: ->
    @viewsFactory.create()

modula.export('frames/extendables/views_factory', Frames.Extendables.ViewsFactory)
