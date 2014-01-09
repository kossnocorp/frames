Frames = window.Frames or require('frames')

class State

  constructor: (defaultState = null, options = {}) ->
    @states ?= []

    if options.states?
      @states.push(state) for state in options.states

    @events = options.events if options.events?

    if defaultState?
      @states.push(defaultState)
      @default = defaultState

    @__rules = {}
    @__defineEvents()
    @__forceSet(@__default())

  get: ->
    @__state

  set: (state) ->
    if @__isStateDefined(state) and @__isTransitionAllowed(state)
      callback = @__callbackFor(state)
      callback?(@get(), state)
      @__state = state
    else if not @__isStateDefined(state)
      throw "There is not '#{state}' state"
    else
      throw "Transition from '#{@get()}' to '#{state}' is not allowed!"

  reset: ->
    @onReset?(@get(), @__default())
    @__forceSet(@__default())

  availableStates: ->
    @states

  __forceSet: (@__state) ->

  __default: ->
    @default || @states[0]

  __defineEvents: ->
    @__defineEvent(name, rules) for name, rules of @events

  __defineEvent: (name, rules) ->
    @__applyRules(name, rules)
    @[name] = -> @set(rules.to)

  __applyRules: (name, rules) ->
    from = if typeof rules.from is 'object' then rules.from else [rules.from]
    for origin in from
      @__rules[origin] ?= []
      @__rules[origin].push(rules.to)

  __isStateDefined: (state) ->
    @states.indexOf(state) isnt -1

  __isTransitionAllowed: (state) ->
    allowedStates = @__rules[@get()]
    allowedStates and allowedStates.indexOf(state) isnt -1

  __callbackFor: (state) ->
    callbackName = "on_#{state}".camelize(false)
    @[callbackName]

Frames.export('frames/state', State)
