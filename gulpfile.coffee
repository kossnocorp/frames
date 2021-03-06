gulp = require('gulp')
gutil = require('gulp-util')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
header = require('gulp-header')
uglify = require('gulp-uglify')
rename = require('gulp-rename')
karma = require('gulp-karma')

p = require('./package.json')

projectHeader = "/*! #{p.name} (v#{p.version}),\n
                #{p.description},\n
                by #{p.author}\n
                #{new Date().toDateString()} */\n"

sourceFiles = [
  'src/modula.coffee'
  'src/core/frames.coffee'
  'src/core/class_modules/*.coffee'
  'src/core/class.coffee'
  'src/core/state.coffee'
  'src/core/extendables/*.coffee'

  'src/base/factories/*.coffee'
  'src/base/*_modules/*.coffee'
  'src/base/*.coffee'

  'src/core/launcher.coffee'
]

gulp.task 'build', ['karma:release'], ->
  gulp.src(sourceFiles)
    .pipe(coffee(bare: false).on('error', gutil.log))
    .pipe(concat("#{p.name}.js"))
    .pipe(header(projectHeader))
    .pipe(gulp.dest('build/'))

gulp.task 'minify', ['build'], ->
  gulp.src("build/#{p.name}.js")
    .pipe(uglify(outSourceMap: false))
    .pipe(rename(suffix: '.min'))
    .pipe(header(projectHeader))
    .pipe(gulp.dest('build/'))

gulp.task 'karma:release', ->
  gulp.src('')
    .pipe(karma(
      configFile: 'karma.conf.coffee'
      sourceFiles: sourceFiles
    ))

gulp.task 'karma:ci', ->
  gulp.src('')
    .pipe(karma(
      configFile: 'karma.conf.coffee'
      browsers: ['PhantomJS']
      sourceFiles: sourceFiles
    ))

gulp.task 'karma:dev', ->
  gulp.src('')
    .pipe(karma(
      configFile: 'karma.conf.coffee'
      reporters: ['dots']
      action: 'watch'
      sourceFiles: sourceFiles
    ))

gulp.task 'release', ['karma:release', 'build', 'minify']
