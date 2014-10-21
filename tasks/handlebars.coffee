module.exports = (grunt) ->
  dist:
    options:
      namespace: "JST"
      wrapped: true
      processName: (filename) ->
        filename.replace(grunt.option('dest') + "/templates/app/scripts/modules/","").replace("templates/","").replace(".jst","")
    files:
      "<%= grunt.option('dest') %>/scripts/templates.js": ["<%= grunt.option('dest') %>/templates/**/*.jst"]
