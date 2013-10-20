Router = require('framework/model')

describe 'Frames.Model', ->

  it 'inherits from Backbone.Model', ->
    Model::sync.should.be.defined

