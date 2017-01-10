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
    { global: '_',       require: 'lodash' }
    { global: 'Object',  native:  true }
    { global: 'Array',   native:  true }
    { global: 'Number',  native:  true }
    { global: 'String',  native:  true }
    { global: 'Boolean', native:  true }
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
    .pipe coffee(bare: true)
    .pipe gulp.dest('spec')
  gulp.src('coffeespec/support/jasmine.json')
    .pipe gulp.dest('spec/support')
