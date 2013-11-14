Frames = require('framework')
Class = require('framework/class')

class ViewWrapper extends Class

  @create: ->
    true

Frames.export('views_factory_complicated/view_wrapper', ViewWrapper)
