module.exports = (grunt) ->
  options:
    banner: "/*! <%= pkg.name %> <%= grunt.template.today(\"yyyy-mm-dd\") %> */\n"
  build:
    files: [
      "<%= grunt.option('dest') %>/scripts/lemonette.min.js": "<%= grunt.option('dest') %>/scripts/lemonette.js"
      "<%= grunt.option('dest') %>/scripts/lemonette.spell.min.js": "<%= grunt.option('dest') %>/scripts/lemonette.spell.js"
    ]