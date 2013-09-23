#= require_tree ./view_modules

originConfigure = Backbone.View::_configure
originRemove = Backbone.View::remove

class Framework.View extends Backbone.View

  @addToConfigureChain: (fnName) ->
    @configureChain ?= []
    @configureChain.push(fnName)

  @addToRemoveChain: (fnName) ->
    @removeChain ?= []
    @removeChain.push(fnName)

  @include Framework.PubSubModule
  @include Framework.JQueryQuery

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

