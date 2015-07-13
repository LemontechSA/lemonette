module.exports = (grunt) ->
  compile:
    files:
      "<%= grunt.option('dest') %>/scripts/lemonette.js": "<%= grunt.option('dest') %>/lemonette.coffee"
      "<%= grunt.option('dest') %>/scripts/app.js": "<%= grunt.option('dest') %>/app.coffee"