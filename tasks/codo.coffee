module.exports = (grunt) ->
  docs:
    src:  "app/scripts/**/*.coffee"
    dest: "<%= grunt.option('dest') %>/docs"
  options:
    readme: "README.md"