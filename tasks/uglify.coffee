module.exports = (grunt) ->
  options:
    banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"
  build:
    files: [
      "<%= grunt.option('dest') %>/scripts/lemontend.min.js": "<%= grunt.option('dest') %>/scripts/lemontend.js"
      "<%= grunt.option('dest') %>/scripts/lemontend.spell.min.js": "<%= grunt.option('dest') %>/scripts/lemontend.spell.js"
    ]