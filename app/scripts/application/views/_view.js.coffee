@App.module "Views", (Views, App, Backbone, Marionette, $, _) ->

	_.extend Marionette.View::,

		genericThing: ->
      console.log 'generic thing for views :)'
