module.exports = (grunt) ->
  grunt.file.defaultEncoding = 'utf8';

  loadConfig = (path) ->
    glob = require("glob")
    object = {}
    key = undefined
    glob.sync("*",
      cwd: path
    ).forEach (option) ->
      key = option.replace(/\.coffee$/, "")
      object[key] = require(path + option)(grunt)
      return
    object

  config =
    pkg: grunt.file.readJSON("package.json")
  grunt.util._.extend config, loadConfig("./tasks/")
  grunt.initConfig config
  grunt.option 'dest', 'dist'

  buildEnvironment = (env, tasks) ->
    grunt.registerTask env, 'Build', ->
      grunt.option('dest', 'dist')
      grunt.task.run tasks

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  buildEnvironment 'develop', [
    'concat'
    'directives'
    'coffee:compile'
    'cssmin'
    'copy'
    'haml:templates'
    'handlebars'
    'clean'
  ]

  buildEnvironment 'production', [
    'concat'
    'directives'
    'coffee:compile'
    'cssmin'
    'copy'
    'haml:templates'
    'handlebars'
    'uglify'
    'clean'
  ]

  buildEnvironment 'dist', ['production']
  buildEnvironment 'default', ['develop', 'watch']