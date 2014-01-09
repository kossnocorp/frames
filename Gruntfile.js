module.exports = function (grunt) {
  grunt.initConfig({
    karma: {
      options: {
        basePath: '',
        frameworks: ['mocha', 'sinon-chai'],
        files: [
          { pattern: 'spec/fixtures/**/*.html',
            included: true },

          'bower_components/jquery/jquery.js',
          'bower_components/modula/lib/modula.js',
          'bower_components/sugar/release/sugar-full.development.js',
          'bower_components/underscore/underscore.js',
          'bower_components/backbone/backbone.js',
          'bower_components/echoes/index.coffee',
          'bower_components/noted/index.js',

          'src/core/frames.coffee',
          'src/core/class_modules/*.coffee',
          'src/core/class.coffee',
          'src/core/state.coffee',
          'src/core/*.coffee',

          'src/base/*_modules/*.coffee',
          'src/base/*.coffee',

          'spec/**/*_spec.coffee'
        ],
        exclude: [],
        reporters: ['progress'],
        port: 9876,
        colors: true,
        autoWatch: true,
        browsers: ['PhantomJS'],
        captureTimeout: 60000,
        singleRun: false,
        coffeePreprocessor: {
          options: {
            bare: false
          }
        }
      },
      dev: {
        reporters: ['dots']
      },
      release: {
        singleRun: true
      },
      ci: {
        singleRun: true,
        browsers: ['PhantomJS']
      }
    }
  });

  grunt.loadNpmTasks('grunt-karma');
};
