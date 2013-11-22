# TODO: at this moment complicated views factory only works with Modula,
# export to window is not supported

Frames = require('framework')
Class = require('framework/class')

class ViewsFactory extends Class

  VIEW_SELECTOR = '[data-view]'
  APP_SELECTOR = '[data-app]'

  @options:
    viewSelector: VIEW_SELECTOR
    appSelector: APP_SELECTOR

  @create: ->
    @initRemoveEvent()
    @initRefreshEvent()

  @initRemoveEvent: ->
    return if @isRemoveEventInitialized()
    @setRemoveEventAsInitialized()

    # Special event definition
    $.event.special.remove =
      remove: (handleObj) ->
        el = this
        e =
          type: 'remove'
          data: handleObj.data
          currentTarget: el

        handleObj.handler(e)

  @initRefreshEvent: ->

  # private

  @isRemoveEventInitialized: ->
    @_isRemoveEventInitialized ||= false

  @setRemoveEventAsInitialized: ->
    @_isRemoveEventInitialized = true

Frames.registerFactory(ViewsFactory, 'views')

Frames.export('views_factory_complicated', ViewsFactory)
