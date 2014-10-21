module.exports = (grunt) ->
  scripts: ["<%= grunt.option('dest') %>/lemontend.coffee"]
  templates: ["<%= grunt.option('dest') %>/templates"]