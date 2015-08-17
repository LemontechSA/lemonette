class @Lemonette.Layout extends Marionette.Layout

  asyncDownload: ($detonator, fileUrl, successCallback) ->
    $detonator.blur()
    $detonator.prop('disabled', true)
    $.fileDownload fileUrl,
      successCallback: (url) ->
        $detonator.prop('disabled', false)
        successCallback()
        return

class @Lemonette.BackboneView extends Backbone.View
