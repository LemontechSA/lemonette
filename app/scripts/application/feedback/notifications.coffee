"use strict"
@App.module "Notifications", ((Notifications, App, Backbone, Marionette, $, _, toastr) ->

  Notifications.addInitializer ->
    App.commands.setHandler 'alert.show', (options) ->
      opts = 
        css: 'toast-top-full-width'
        type: options.type || 'warning'
        message: options.message || 'You must provide a message'
        success: options.success
        showMethod: 'slideDown'
        title: options.title || "Información Importante"
      $.extend opts, options
      Notifications.showMessage(opts)

    App.commands.setHandler 'info.show', (options) ->
      opts = 
        css: 'toast-top-full-width'
        type: options.type || 'info'
        message: options.message || 'You must provide a message'
        success: options.success
      $.extend opts, options
      Notifications.showMessage(opts)

  Toast = (type, css, title, message) ->
    @type = type
    @css = css
    @message = message
    @title = title
    return
  
  Notifications.showMessage = (options = {}) ->
    t = new Toast(options.type, options.css, options.title, options.message)
    toastr.options.extendedTimeOut = 0
    toastr.options.timeOut = options.timeOut || 5000
    toastr.options.showMethod = options.showMethod || "slideDown"
    toastr.options.hideMethod = options.hideMethod || 'slideUp'
    toastr.options.hideDuration = 200
    toastr.options.positionClass = t.css || "toast-top-full-width"
    toastr.options.onclick = ->
      toastr.clear()  
      options.onclick() if options.onclick
    toastr[t.type] t.message, t.title
    $('.toast .action').on 'click', ->
      toastr.clear()
      callback = $(this).data('callback')
      options[callback]() if callback and options[callback]
), toastr