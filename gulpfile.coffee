gulp = require 'gulp'
changed = require 'gulp-changed'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'

sources =
  './server/src/**/*.coffee': './server/lib/'
  './public/js/src/**/*.coffee': './public/js/lib/'

apply_to_sources = (fn) ->
  fn src, dest for src, dest of sources

compile_coffee = (src, dest, to_watch) ->
  gulp.src src
    .pipe if to_watch then watch() else changed dest
    .pipe coffee()
    .pipe gulp.dest dest

compile_changed = (src, dest) ->
  compile_coffee src, dest, no

complile_with_watch = (src, dest) ->
  compile_coffee src, dest, yes

gulp.task 'build', ->
  apply_to_sources compile_changed

gulp.task 'watch', ->
  apply_to_sources complile_with_watch

gulp.task 'default', [
  'build'
]
