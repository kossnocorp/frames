Frames = window.Frames or require('framework')
PubSubModule = Frames.PubSubModule or require('framework/pub_sub_module')
JqueryQueryModule = Frames.JqueryQueryModule or require('framework/jquery_query_module')
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

Frames.export('framework/view', View)
