module.exports = (grunt) ->
  vendor:
    files:
      "<%= grunt.option('dest') %>/styles/vendor.css": [
        'bower_components/backgrid/lib/backgrid.min.css'
        'bower_components/backgrid-paginator/backgrid-paginator.min.css'
        'bower_components/fontawesome/css/font-awesome.min.css'
        'bower_components/toastr/toastr.min.css'
        'bower_components/intro.js/minified/intro.min.css'
      ]
