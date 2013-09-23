class @Framework

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

