class Frames

  @start: ->
    return unless @factories
    Factory.create() for id, Factory of @factories

  @stop: ->
    return unless @factories
    Factory.destroy() for id, Factory of @factories

  @registerFactory: (Factory, type) ->
    @factoryCounter ?= 0
    @factories ?= {}
    id = type or "factory_#{@factoryCounter++}"
    @factories[id] = Factory
    id

  @export: (name, Module) ->
    if modula?
      modula.export(name, Module)
    else
      @__exportToWindow(name, Module)

  @__exportToWindow: (name, Module) ->
    chunks = name.split('/')
    lastChunk = chunks.pop()
    @__getOrCreateNamespacePath(chunks)[@__classify(lastChunk)] = Module

  @__getOrCreateNamespacePath: (chunks) ->
    chunks.reduce(@__getOrCreateNamespaceChunk.bind(@), window)

  @__getOrCreateNamespaceChunk: (object, chunk) ->
    object[@__classify(chunk)] ?= {}

  @__classify: (name) ->
    name.camelize()

Frames.export('framework', Frames)
