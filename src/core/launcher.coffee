Frames = window.Frames or require('frames')
Class = window.Frames?.Class or require('frames/class')
State = window.Frames?.State or require('frames/state')

class Launcher extends Class

  constructor: ->
    events =
      setReady: from: 'loaded', to: 'ready'
      setCreated: from: 'ready', to: 'created'

    states = ['loaded', 'ready', 'created']

    @stage = new State('loaded', {states, events})
    #@reset()
    @bindReady(@setReady.bind(@))

  reset: ->
    @stage.reset()

  setReady: ->
    @stage.setReady()
    Frames.start()

  getStage: ->
    @stage.get()

  bindReady: (fn) ->
    $(fn)

  hook: (stage, fn) ->
    fn()

Frames.export('frames/launcher', Launcher)
