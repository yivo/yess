gulp        = require 'gulp'
connect     = require 'gulp-connect'
concat      = require 'gulp-concat'
coffee      = require 'gulp-coffee'
preprocess  = require 'gulp-preprocess'
iife        = require 'gulp-iife'
uglify      = require 'gulp-uglify'
rename      = require 'gulp-rename'
del         = require 'del'
plumber     = require 'gulp-plumber'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ['concat', 'wrap'], ->

gulp.task 'concat', ->
  gulp.src('source/manifest.coffee')
  .pipe plumber()
  .pipe preprocess()
  .pipe concat('yess.coffee')
  .pipe gulp.dest('build')
  .pipe coffee(bare: yes)
  .pipe concat('yess.js')
  .pipe gulp.dest('build')

gulp.task 'wrap', ['concat'], ->
  gulp.src('build/**/*')
  .pipe plumber()
  .pipe iife(dependencies: [name: 'lodash', as: '_'])
  .pipe gulp.dest('build')

gulp.task 'build-min', ['build'], ->
  gulp.src('build/yess.js')
  .pipe uglify()
  .pipe rename('yess.min.js')
  .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']

gulp.task 'coffeespec', ->
  del.sync 'spec/**/*.js'
  gulp.src('coffeespec/**/*.coffee')
  .pipe coffee(bare: yes)
  .pipe gulp.dest('spec')