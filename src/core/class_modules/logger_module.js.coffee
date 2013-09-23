LEVELS = 'debug info warn error'.split(' ')

Framework.LoggerModule =

  included: (klass) ->
    @echo ?= Echo()
    klass.extend @

  log: (text, options = {}) ->
    @logger(text, options)

  logger: (args...) ->
    Framework.LoggerModule.echo(args...)

for level in LEVELS
  Framework.LoggerModule[level] = (text, options) ->
    @log(text, Object.extended(options).clone().merge {level})
