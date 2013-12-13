Frames = require('framework')
Class = require('framework/class')

class ViewHooks extends Class

  onInit: (callback) ->
    @onInitCallbacks().push(callback)

  onInitCallbacks: ->
    @_onInitCallbacks ||= []

  init: (args...) ->
    callback(args...) for callback in @onInitCallbacks()


  onActivation: (callback) ->
    @onActivationCallbacks().push(callback)

  onActivationCallbacks: ->
    @_onActivationCallbacks ||= []

  activate: (args...) ->
    callback(args...) for callback in @onActivationCallbacks()


  onUnload: (callback) ->
    @onUnloadCallbacks().push(callback)

  onUnloadCallbacks: ->
    @_onUnloadCallbacks ||= []

  unload: (args...) ->
    callback(args...) for callback in @onUnloadCallbacks()

Frames.export('views_factory_complicated/view_hooks', ViewHooks)
