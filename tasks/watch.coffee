module.exports = (grunt) ->
  vendor:
    files: ['bower_components/**/*.js', 'app/vendor/bower/**/*.css']
    tasks: ['concat:vendor', 'cssmin:vendor']

  scripts:
    files: ['app/scripts/**/*.coffee']
    tasks: ['directives', 'coffee:compile', 'clean:scripts']

  templates:
    files: ['app/scripts/**/*.haml']
    tasks: ['haml:templates', 'handlebars', 'clean:templates']

  images:
    files: ['app/images/**']
    tasks: ['copy:images']

  configFiles:
    files: ['Gruntfile.coffee', 'tasks/*.coffee']
    options:
      reload: true

