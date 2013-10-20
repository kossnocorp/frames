Frames = window.Frames or require('framework')
PubSubModule = window.Frames.PubSubModule or require('framework/pub_sub_module')
JqueryQueryModule = window.Frames.JqueryQueryModule or require('framework/jquery_query_module')
Backbone = window.Backbone

originConfigure = Backbone.View::_configure
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

  _configure: (options) ->
    configureChain = @constructor.configureChain
    if configureChain
      @[fnName].call(@, options) for fnName in configureChain

    originConfigure.call(@, options)

  remove: ->
    removeChain = @constructor.removeChain
    if removeChain
      @[fnName].call(@) for fnName in removeChain

    originRemove.call(@)

Frames.export('framework/view', View)
