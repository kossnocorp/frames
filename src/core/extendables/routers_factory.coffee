Frames = modula.require 'frames'

class Frames.Extendables.RoutersFactory

  constructor: ->
    @routersFactory = modula.require 'frames/routers_factory'

  extended: (args...) ->
    [routersFactory] = args
    @routersFactory = routersFactory

  ready: ->
    @routersFactory.create()

modula.export('frames/extendables/routersFactory', Frames.Extendables.RoutersFactory)
