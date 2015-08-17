class @Lemonette.Layout extends Marionette.Layout

  asyncDownload: ($detonator, text, fileUrl) ->
    $detonator.blur()
    $detonator.prop('disabled', true)
    $btn_icon = $detonator.children('i')
    $btn_text = $detonator.children('span')
    btn_class = $detonator.prop('class')
    icon_class = $btn_icon.prop('class')
    icon_text = $btn_text.text()
    $detonator.prop('class', 'btn btn-disabled')
    $btn_icon.prop('class', 'fa fa-refresh fa-spin')
    $btn_text.text(text)
    $.fileDownload fileUrl,
      successCallback: (url) ->
        $detonator.prop('disabled', false)
        $btn_icon.prop('class', icon_class)
        $detonator.prop('class', btn_class)
        $btn_text.text(icon_text)
        return

class @Lemonette.BackboneView extends Backbone.View
