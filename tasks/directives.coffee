module.exports = (grunt) ->
  coffees:
    files:
      "<%= grunt.option('dest') %>/lemontend.coffee": 'app/scripts/lemontend.coffee'
