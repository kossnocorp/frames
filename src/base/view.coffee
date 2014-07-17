Frames = modula.require('frames')
Backbone = window.Backbone

originRemove = Backbone.View::remove

class Frames.View extends Backbone.View

  @addToConfigureChain: (fnName) ->
    @configureChain ?= []
    @configureChain.push(fnName)

  @addToRemoveChain: (fnName) ->
    @removeChain ?= []
    @removeChain.push(fnName)

  constructor: (options) ->
    super

    configureChain = @constructor.configureChain
    if configureChain
      @[fnName].call(@, options) for fnName in configureChain

  remove: ->
    removeChain = @constructor.removeChain
    if removeChain
      @[fnName].call(@) for fnName in removeChain

    originRemove.call(@)

modula.export('frames/view', Frames.View)
