module.exports = (grunt) ->
  vendor:
    files: [
      src: [
        'bower_components/jquery/dist/jquery.js'
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
        'bower_components/toastr/toastr.min.js'
        'bower_components/intro.js/minified/intro.min.js'
        'bower_components/jquery.cookie/jquery.cookie.js'
        'bower_components/accounting/accounting.min.js'
      ]
      dest: "<%= grunt.option('dest') %>/scripts/vendor.js"
    ]

  spell:
    files: [
      src: [
        'app/scripts/libs/googiespell/AJS.js'
        'app/scripts/libs/googiespell/cookiesupport.js'
        'app/scripts/libs/googiespell/googiespell_multiple.js'
        'app/scripts/libs/googiespell/googiespell.js'
      ]
      dest: "<%= grunt.option('dest') %>/scripts/lemonette.spell.js"
    ]
