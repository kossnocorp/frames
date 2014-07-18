Frames = modula.require('frames')
Backbone = window.Backbone
PubSubModule = modula.require('frames/pub_sub_module')

class Frames.Router extends Backbone.Router

  _bindRoutes: ->
    @createEmitterAndReceiver()
    Backbone.Router::_bindRoutes.call(@)

  createEmitterAndReceiver: ->
    @broker = PubSubModule.broker
    @emitter = new Noted.Emitter(@broker, @)
    @receiver = new Noted.Receiver(@broker, @)

  emit: (message, body, options) ->
    @emitter.emit(message, body, options)

  listen: (message, callback, options) ->
    @receiver.listen(message, callback, options)

  unsubscribe: (message, callback, context) ->
    @broker.unsubscribe(message, callback, @)

modula.export('frames/router', Frames.Router)
