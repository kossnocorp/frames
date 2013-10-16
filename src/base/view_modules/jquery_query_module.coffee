Framework = window.Framework or require('framework')

JQueryQueryModule =

  included: (klass) ->
    klass.addToConfigureChain('buildQueryFunctions')

  buildQueryFunctions: ->
    return unless @els
    for fnName, dirtyQuery of @els
      do (fnName, dirtyQuery) =>
        [__, isCached, query] = dirtyQuery.match(/^(cached)?\s?(.+)/)
        if isCached
          privateName = "__#{fnName}"
          dropFnName = "#{fnName}_drop".camelize()
          @[fnName] = -> @[privateName] ||= @$(query)
          @[dropFnName] = -> @[privateName] = undefined
        else
          @[fnName] = -> @$(query)

Framework.export('framework/jquery_query_module', JQueryQueryModule)
