module.exports = (config) ->
  config.set
    preprocessors: '**/*.coffee': ['coffee'], '**/*.html': ['html2js']
    basePath: ''
    frameworks: ['mocha', 'chai-sinon']
    files: [
      { pattern: 'spec/fixtures/**/*.html', included: true },

      'bower_components/jquery/dist/jquery.js'
      'bower_components/modula/lib/modula.js'
      'bower_components/sugar/release/sugar-full.development.js'
      'bower_components/underscore/underscore.js'
      'bower_components/backbone/backbone.js'
      'bower_components/echoes/index.coffee'
      'bower_components/noted/index.js'

      'src/core/frames.coffee'
      'src/core/class_modules/*.coffee'
      'src/core/class.coffee'
      'src/core/state.coffee'
      'src/core/*.coffee'

      'src/base/*_modules/*.coffee'
      'src/base/*.coffee'

      'spec/**/*_spec.coffee'
    ]
    exclude: []
    reporters: ['progress']
    port: 9876
    colors: true
    autoWatch: true
    captureTimeout: 60000
    singleRun: false

    browsers: ['PhantomJS']
