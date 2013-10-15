module.exports = function (grunt) {
  grunt.initConfig({
    karma: {
      options: {
        basePath: '',
        frameworks: ['mocha', 'chai'],
        files: ['src/*.coffee', 'spec/*_spec.coffee'],
        exclude: [],
        reporters: ['progress'],
        port: 9876,
        colors: true,
        autoWatch: true,
        browsers: ['PhantomJS'],
        captureTimeout: 60000,
        singleRun: false
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
