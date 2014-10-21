module.exports = (grunt) ->
  fonts:
    expand: true
    flatten: true
    src: ['bower_components/bootstrap/dist/fonts/**', 'bower_components/fontawesome/fonts/**']
    dest: "<%= grunt.option('dest') %>/fonts/"
    filter: 'isFile'

  images:
    expand: true
    flatten: true
    src: ['app/images/**', 'bower_components/select2/*.gif', 'bower_components/select2/*.png']
    dest: "<%= grunt.option('dest') %>/images/"
    filter: 'isFile'

  libs:
    expand: true
    flatten: true
    src: ['bower_components/select2/select2-spinner.gif', 'bower_components/select2/select2.png', 'bower_components/select2/select2x2.png']
    dest: "<%= grunt.option('dest') %>/styles/"
    filter: 'isFile'