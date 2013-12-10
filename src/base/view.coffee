Frames = window.Frames or require('frames')
PubSubModule = Frames.PubSubModule or require('frames/pub_sub_module')
JqueryQueryModule = Frames.JqueryQueryModule or require('frames/jquery_query_module')
Backbone = window.Backbone

originRemove = Backbone.View::remove

class View extends Backbone.View

  @addToConfigureChain: (fnName) ->
    @configureChain ?= []
    @configureChain.push(fnName)

  @addToRemoveChain: (fnName) ->
    @removeChain ?= []
    @removeChain.push(fnName)

  @include PubSubModule
  @include JqueryQueryModule

  constructor: (options) ->
    configureChain = @constructor.configureChain
    if configureChain
      @[fnName].call(@, options) for fnName in configureChain

    super

  remove: ->
    removeChain = @constructor.removeChain
    if removeChain
      @[fnName].call(@) for fnName in removeChain

    originRemove.call(@)

Frames.export('frames/view', View)
