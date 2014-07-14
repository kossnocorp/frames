Frames = modula.require('frames')
Backbone = window.Backbone

class Router extends Backbone.Router

  _bindRoutes: ->
    @createEmitterAndReceiver()
    Backbone.Router::_bindRoutes.call(@)

  createEmitterAndReceiver: ->
    @broker = Frames.PubSubModule.broker
    @emitter = new Noted.Emitter(@broker, @)
    @receiver = new Noted.Receiver(@broker, @)

  emit: (message, body, options) ->
    @emitter.emit(message, body, options)

  listen: (message, callback, options) ->
    @receiver.listen(message, callback, options)

  unsubscribe: (message, callback, context) ->
    @broker.unsubscribe(message, callback, @)

modula.export('frames/router', Router)
