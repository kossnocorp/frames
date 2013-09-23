Framework.PubSubModule =

  included: (klass) ->
    @broker = new Noted.Broker()
    klass.addToConfigureChain('createEmitterAndReceiver')

  createEmitterAndReceiver: ->
    @broker = Framework.PubSubModule.broker
    @emitter = new Noted.Emitter(@broker, @)
    @receiver = new Noted.Receiver(@broker, @)

  emit: (message, body, options) ->
    @emitter.emit(message, body, options)

  listen: (message, callback, options) ->
    @receiver.listen(message, callback, options)

  unsubscribe: (message, callback, context) ->
    @broker.unsubscribe(message, callback, @)
