gulp = require 'gulp'
gutil = require 'gulp-util'
changed = require 'gulp-changed'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'
mocha = require 'gulp-mocha'

sources =
  './server/src/**/*.coffee': './server/build/'
  './public/js/src/**/*.coffee': './public/js/build/'

apply_to_sources = (fn) ->
  fn src, dest for src, dest of sources

compile_coffee = (src, dest, to_watch) ->
  (if to_watch then watch(src) else gulp.src(src).pipe(changed dest))
    .pipe(coffee()).on 'error', (err) -> gutil.log err.toString()
    .pipe gulp.dest dest

compile_changed = (src, dest) ->
  compile_coffee src, dest, no

complile_with_watch = (src, dest) ->
  compile_coffee src, dest, yes

gulp.task 'build', ->
  apply_to_sources compile_changed

gulp.task 'watch', ->
  apply_to_sources complile_with_watch

gulp.task 'test', ->
  gulp.src './server/build/test/**/*.js'
    .pipe mocha reporter: 'spec'

gulp.task 'default', ['build']
