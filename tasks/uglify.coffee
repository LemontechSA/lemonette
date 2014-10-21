module.exports = (grunt) ->
  options:
    banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"
  build:
    src: "<%= grunt.option('dest') %>/scripts/lemontend.js"
    dest: "<%= grunt.option('dest') %>/scripts/lemontend.min.js"