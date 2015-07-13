module.exports = (grunt) ->
  scripts: ["<%= grunt.option('dest') %>/app.coffee", "<%= grunt.option('dest') %>/lemonette.coffee"]
  templates: ["<%= grunt.option('dest') %>/templates"]