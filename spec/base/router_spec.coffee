Router = require('framework/router')

describe 'Framework.Router', ->

  it 'inherits from Backbone.Router', ->
    Router::route.should.be.defined

