module.exports = (grunt) ->
  templates:
    files: grunt.file.expandMapping(["app/scripts/**/*.haml"], "<%= grunt.option('dest') %>/templates/",
      rename: (base, path) ->
        name = base + path.replace(/\.haml$/, ".jst")
        name
    )