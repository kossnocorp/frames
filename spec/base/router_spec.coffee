Router = require('framework/router')

describe 'Frames.Router', ->

  it 'inherits from Backbone.Router', ->
    Router::route.should.be.defined

