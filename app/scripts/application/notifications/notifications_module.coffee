###
This module contains helpers to show notifications
Requires:
  * Toastr
@see https://github.com/CodeSeven/toastr Toastr
###
class @Lemonette.NotificationsModule extends Lemonette.Module

  ###
    Show an alert toast. Used for errors and warnings
    * This method is accessible via command: *App.execute('alert.show')*
    @private
    @param [Object] options
    @option options [String] type default: *warning* can be: **error** **warning**
    @option options [String] title of message
    @option options [String] message
    @option options [Function] success callback
    @example
      'alert.show', {title: 'No autorizado', message: JSON.parse(jqXHR.responseText).message}) if jqXHR.status > 400
  ###
  showAlert: (options) ->
    opts =
      css: 'toast-top-full-width'
      type: options.type || 'warning'
      message: options.message || 'You must provide a message'
      success: options.success
      showMethod: 'slideDown'
      title: options.title || "Información Importante"
    $.extend opts, options
    @showMessage(opts)

  ###
    Show an info toast. Used for success or information feedback
    * This method is accessible via command: *App.execute('info.show')*
    @private
    @param [Object] options
    @option options [String] type default: *info* can be: **success** **info**
    @option options [String] title of message
    @option options [String] message
    @option options [Function] success callback
  ###
  showInfo: (options) ->
    opts =
      css: 'toast-top-full-width'
      type: options.type || 'info'
      message: options.message || 'You must provide a message'
      success: options.success
    $.extend opts, options
    @showMessage(opts)

  ###
    @private
    Create new Object to show in Toastr
  ###
  Toast: (type, css, title, message) ->
    @type = type
    @css = css
    @message = message
    @title = title
    return

  ###
    @private
    Show a Toastr with options
    @param [Object] options
    @option options [String] type [warning, error, info, success]
    @option options [String] title of message
    @option options [String] message
    @option options [Integer] timeOut automatically close at timeOut milliseconds
    @option options [String] showMethod [slideDonw, slideUp, FadeIn, etc]
    @option options [String] hideMethod [slideDonw, slideUp, FadeIn, etc]
    @option options [String] css option for type ex: 'toast-top-full-width'
    @option options [Function] wherever callback, you need add **data-callback=name**
            to a button inside toastr [.toast .action]
    @see https://github.com/CodeSeven/toastr
  ###
  showMessage: (options = {}) ->
    toastr.clear()
    t = new @Toast(options.type, options.css, options.title, options.message)
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

  ###
  Register commadnds for acces to show alert and show info through Application
  ###
  onStart: ->
    @App.commands.setHandler 'alert.show', (options) =>
      @showAlert options
    @App.commands.setHandler 'info.show', (options) =>
      @showInfo options