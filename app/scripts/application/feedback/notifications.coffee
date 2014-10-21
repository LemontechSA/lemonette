"use strict"
@App.module "Notifications", ((Notifications, App, Backbone, Marionette, $, _, toastr) ->

  Notifications.addInitializer ->
    App.commands.setHandler 'alert.show', (options) ->
      opts = 
        positionClass: 'toast-top-center'
        type: options.type || 'warning'
        message: options.message || 'You must provide a message'
        success: options.success
        showMethod: 'slideDown'
        newestOnTop: true
        title: "Información Importante"
      $.extend opts, options
      Notifications.showMessage(opts)

    App.commands.setHandler 'info.show', (options) ->
      opts = 
        positionClass: 'toast-top-center'
        type: options.type || 'info'
        message: options.message || 'You must provide a message'
        success: options.success
        newestOnTop: false
      $.extend opts, options
      Notifications.showMessage(opts)

  Notifications.showMessage = (options = {}) ->
    toastr.options.positionClass = options.positionClass
    toastr.options.extendedTimeOut = options.extendedTimeOut
    toastr.options.timeOut = options.timeOut
    toastr.options.hideDuration = options.hideDuration || 200
    toastr.options.extendedTimeOut = options.extendedTimeOut || 100000
    toastr.options.timeOut = options.timeOut || 5000
    toastr.options.showDuration = options.showDuration || 200
    toastr.options.closeButton = options.closeButton || true
    toastr.options.newestOnTop = options.newestOnTop
    toastr.options.showMethod = options.showMethod
    toastr.options.onclick = ->
      toastr.clear()  
      options.onclick() if options.onclick
    toastr.options.hideMethod = options.hideMethod || 'slideUp'
    toastr.clear()
    toastr[options.type] options.message, options.title
    $('.toast .action').on 'click', ->
      toastr.clear()
      callback = $(this).data('callback')
      options[callback]() if callback and options[callback]
), toastr