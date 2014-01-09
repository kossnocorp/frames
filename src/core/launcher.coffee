Frames = window.Frames or require('frames')
Class = window.Frames?.Class or require('frames/class')
State = window.Frames?.State or require('frames/state')

class Launcher extends Class

  constructor: ->
    @__hooks = {}
    @__passedStages = ['loaded']

    events =
      setReady: from: 'loaded', to: 'ready'
      setCreated: from: 'ready', to: 'created'

    states = ['loaded', 'ready', 'created']

    @stage = new State('loaded', {states, events})

    @stage.onReady = @__stageTransition 'ready', =>
      Frames.start()
      setTimeout((=> @stage.setCreated()), 0)

    @stage.onCreated = @__stageTransition('created')

    @__bindReady(@setReady.bind(@))

  reset: ->
    @__passedStages = ['loaded']
    @stage.reset()

  setReady: ->
    @stage.setReady()

  getStage: ->
    @stage.get()

  hook: (stage, fn) ->
    @__hooks[stage] ?= []
    @__hooks[stage].push(fn)

    @__call(fn) if @__passedStages.indexOf(stage) isnt -1

  __bindReady: (fn) ->
    $(fn)

  __stageTransition: (stage, after) ->
    =>
      @__passedStages.push(stage)
      @__callStage(stage)
      after?()

  __callStage: (stage) ->
    if @__hooks[stage]
      @__call(fn) for fn in @__hooks[stage]

  __call: (fn) ->
    setTimeout(fn, 0)

Frames.export('frames/launcher', Launcher)
