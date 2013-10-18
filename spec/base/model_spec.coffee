Router = require('framework/model')

describe 'Framework.Model', ->

  it 'inherits from Backbone.Model', ->
    Model::sync.should.be.defined

