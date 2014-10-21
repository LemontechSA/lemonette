"use strict"
@App.module "Ajax", (Ajax, App, Backbone, Marionette, $, _) ->
  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    try
      App.execute('alert.show', {title: 'No autorizado', message: JSON.parse(jqXHR.responseText).message}) if jqXHR.status > 400
    catch
      console.log 'Ajax Error'