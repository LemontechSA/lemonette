module.exports = (grunt) ->
  coffees:
    files: 
      "<%= grunt.option('dest') %>/app.coffee": 'app/scripts/app.coffee'
  coffes2: 
  	files: 
      "<%= grunt.option('dest') %>/lemonette.coffee": 'app/scripts/lemonette.coffee'