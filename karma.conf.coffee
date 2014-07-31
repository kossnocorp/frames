karmaCliData = JSON.parse(process.argv[2])

fixtureFiles = [
  'spec/fixtures/**/*.html'
]

vendorFiles = [
  'bower_components/jquery/dist/jquery.js'
  'bower_components/sugar/release/sugar-full.development.js'
  'bower_components/underscore/underscore.js'
  'bower_components/backbone/backbone.js'
  'bower_components/echoes/index.coffee'
  'bower_components/noted/lib/noted.js'
  'bower_components/vtree/build/vtree.js'
]

sourceFiles = karmaCliData.sourceFiles

specFiles = fixtureFiles
  .concat(vendorFiles)
  .concat(sourceFiles)
  .concat([
    'spec/**/*_spec.coffee'
  ])

module.exports = (config) ->
  config.set
    preprocessors:
      '**/*.coffee': ['coffee'],
      '**/*.html': ['html2js']
    basePath: ''
    frameworks: ['mocha', 'sinon-chai']
    files: specFiles
    exclude: []
    reporters: ['progress']
    port: 9876
    colors: true
    autoWatch: true
    browsers: ['PhantomJS']
    captureTimeout: 60000
    singleRun: false

    coffeePreprocessor:
      options: {bare: false}
