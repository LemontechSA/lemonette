"use strict"
@App.module "Routers", (Routers, App, Backbone, Marionette, $, _) ->

  class Routers.TrackableRouter extends Marionette.AppRouter
    constructor: (options) ->
      super
      @on 'route', (page, options) ->
        ga 'send', 'pageview', page, page
      return
