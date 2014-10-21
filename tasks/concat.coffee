module.exports = (grunt) ->
  vendor:
    files: [
      src: [
        'bower_components/underscore/underscore.js'
        'bower_components/backbone/backbone.js'
        'bower_components/backbone.babysitter/lib/backbone.babysitter.js'
        'bower_components/backbone.wreqr/lib/backbone.wreqr.js'
        'bower_components/backbone.marionette/lib/backbone.marionette.js'
        'bower_components/backbone.paginator/lib/backbone.paginator.js'
        'bower_components/backbone-filtered-collection/backbone-filtered-collection.js'
        'bower_components/handlebars/handlebars.js'
        'bower_components/handlebars-form-helpers/dist/handlebars.form-helpers.min.js'
        'bower_components/i18next/i18next.min.js'
        'bower_components/backgrid/lib/backgrid.min.js'
        'bower_components/backgrid-paginator/backgrid-paginator.js'
        'bower_components/momentjs/min/moment-with-locales.min.js'
      ]
      dest: "<%= grunt.option('dest') %>/scripts/vendor.js"
    ]