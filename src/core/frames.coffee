class Frames

  @Extendables: {}

  @createExtendables: ->
    @extendables ?= {}
    for own name, klass of @Extendables
      @__initExtendable(name, klass)

  @extend: (moduleName, args...) ->
    unless @extendables[moduleName]?
      throw "Trying to extend module #{moduleName.camelize()}, but it is not registered."
    @extendables[moduleName].extended(args...)

  @registerLauncher: (Launcher) ->
    @__LauncherClass = Launcher

  @launch: ->
    throw 'You try to launch Frames, but no launcher class is registered.' unless @__LauncherClass?
    @__launcher = new @__LauncherClass()

  @hook: (type, callback) ->
    throw 'Launcher is not registered' unless @__launcher
    @__launcher.hook(type, callback)

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

  @__initExtendable: (name, klass) ->
    unless Object.isFunction(klass::extended)
      throw 'Trying to initialize extendable module, but #extended method is not specified for it.'
    @extendables[name.underscore()] = new klass()

modula.export('frames', Frames)

