@App.module "Views", (Views, App, Backbone, Marionette, $, _) ->

	class Views.ItemView extends Marionette.ItemView
    onShow: ->
      if @help_step > 0
        App.execute "help:show", @help_step
