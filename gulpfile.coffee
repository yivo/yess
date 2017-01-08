gulp       = require 'gulp'
concat     = require 'gulp-concat'
coffee     = require 'gulp-coffee'
preprocess = require 'gulp-preprocess'
iife       = require 'gulp-iife-wrap'
del        = require 'del'
plumber    = require 'gulp-plumber'

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  dependencies = [
    { global: '_', require: 'lodash' }
    { global: 'Object',  native: yes }
    { global: 'Array',  native: yes }
    { global: 'Number',  native: yes }
    { global: 'String',  native: yes }
    { global: 'Boolean',  native: yes }
  ]

  gulp.src('source/__manifest__.coffee')
    .pipe plumber()
    .pipe preprocess()
    .pipe iife({global: '_', dependencies})
    .pipe concat('yess.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('yess.js')
    .pipe gulp.dest('build')

gulp.task 'coffeespec', ->
  del.sync 'spec/**/*'
  gulp.src('coffeespec/**/*.coffee')
    .pipe coffee(bare: yes)
    .pipe gulp.dest('spec')
  gulp.src('coffeespec/support/jasmine.json')
    .pipe gulp.dest('spec/support')
