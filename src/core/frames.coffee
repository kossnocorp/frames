class @Frames

  @Extendables: {}

  @createExtendables: ->
    @extendables ?= {}
    for own name, klass of @Extendables
      unless Object.isFunction(klass::extended)
        throw 'Trying to initialize extendable module, but #extended method is not specified for it.'
      @extendables[name.underscore()] = new klass()

  @extend: (moduleName, args...) ->
    unless @extendables[moduleName]?
      throw "Trying to extend module #{moduleName.camelize()}, but it is not registered."
    @extendables[moduleName].extended(args...)

  @registerLauncher: (Launcher) ->
    @__launcher = new Launcher()

  @hook: (type, callback) ->
    throw 'Launcher is not registered' unless @__launcher
    @__launcher.hook(type, callback)

  @start: ->
    extendable.ready?() for own name, extendable of @extendables

  @stop: ->

modula.export('frames', Frames)

