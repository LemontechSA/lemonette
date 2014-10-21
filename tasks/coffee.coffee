module.exports = (grunt) ->
  compile:
    files:
      "<%= grunt.option('dest') %>/scripts/lemontend.js": "<%= grunt.option('dest') %>/lemontend.coffee"