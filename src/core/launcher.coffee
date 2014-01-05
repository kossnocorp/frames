Frames = window.Frames or require('frames')
Class = window.Frames?.Class or require('frames/class')

class Launcher extends Class

  @attrReader('state')

  constructor: ->
    @__state = 'loaded'

Frames.export('frames/launcher', Launcher)
