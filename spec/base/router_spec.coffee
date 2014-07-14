Router = modula.require('frames/router')

describe 'Frames.Router', ->

  it 'inherits from Backbone.Router', ->
    Router::route.should.be.defined

