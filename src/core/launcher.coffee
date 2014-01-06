Frames = window.Frames or require('frames')
Class = window.Frames?.Class or require('frames/class')

class Launcher extends Class

  @attr('state')

  constructor: ->
    @reset()
    @bindReady(@setReady.bind(@))

  reset: ->
    @setState('loaded')

  setReady: ->
    @setState('ready')
    Frames.start()

  bindReady: (fn) ->
    $(fn)

  hook: (stage, fn) ->
    fn()

Frames.export('frames/launcher', Launcher)
