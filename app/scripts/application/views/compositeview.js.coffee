@App.module "Views", (Views, App, Backbone, Marionette, $, _) ->

  class Views.CompositeView extends Marionette.CompositeView
    itemViewEventPrefix: "childview"
    onShow: ->
      if @help_step > 0
        App.Utils.showHelp(@help_step)