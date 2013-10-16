Framework = window.Framework or require('framework')
PubSubModule = window.Framework.PubSubModule or require('framework/pub_sub_module')
JQueryQueryModule = window.Framework.JQueryQueryModule or require('framework/jquery_query_module')
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
  @include JQueryQueryModule

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

Framework.export('framework/view', View)
