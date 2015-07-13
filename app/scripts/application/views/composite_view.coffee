class @Lemonette.CompositeView extends Marionette.CompositeView
  itemViewEventPrefix: "childview"
  onShow: ->
    if @help_step > 0
      Lemonette.AppInstance.Utils.showHelp(@help_step)