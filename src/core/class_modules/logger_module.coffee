Frames = window.Frames || require('frames')
Echo = window.Echo

LEVELS = 'debug info warn error'.split(' ')

LoggerModule =

  included: (klass) ->
    @echo ?= Echo()
    klass.extend @

  log: (text, options = {}) ->
    @logger(text, options)

  logger: (args...) ->
    LoggerModule.echo(args...)

for level in LEVELS
  LoggerModule[level] = (text, options) ->
    @log(text, Object.extended(options).clone().merge {level})

Frames.export('frames/logger_module', LoggerModule)
