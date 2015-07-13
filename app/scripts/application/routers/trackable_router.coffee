###
@see http://marionettejs.com/docs/v2.4.0/marionette.approuter.html Marionette.AppRouter
Base router, enable google analytics track
@example Create a TrackableRouter
  
  class MyRouter extends App.Routers.TrackableRouter
    appRoutes:
      "myroute":  "mymethod"

###
class @Lemonette.TrackableRouter extends Marionette.AppRouter
  constructor: (options) ->
    super
    @on 'route', (page, options) ->
      ga 'send', 'pageview', page, page
    return
