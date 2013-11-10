ViewModel = require('framework/view_model')

describe 'Frames.ViewModel', ->

  it 'inherits from Backbone.Model', ->
    ViewModel::sync.should.be.defined

