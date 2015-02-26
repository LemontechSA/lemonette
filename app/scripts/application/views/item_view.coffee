class @Lemonette.ItemView extends Marionette.ItemView
  onShow: ->
    if @help_step > 0
      Lemonette.AppInstance.execute "help:show", @help_step
