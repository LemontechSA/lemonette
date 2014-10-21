"use strict"
@App.module "DateHelper", (DateHelper, App, Backbone, Marionette, $, _) ->

  class DateHelper.D
    _d: {}
    constructor: (date) ->
      @_d = moment(date) if date instanceof String or typeof date == 'string'
      @_d = moment(date) if date instanceof Date
      @_d = moment(new Date()) if !date
      @_d = date if typeof date._d == 'object'

    toString: (format = 'YYYY-MM-DD') ->
      @_d.format(format)

    isToday: ->
      @_d.isSame(moment().format('YYYY-MM-DD'))

    startOfWeek: ->
      new DateHelper.D(@_d.startOf('isoWeek').format('YYYY-MM-DD'))

    endOfWeek: ->
      new DateHelper.D(@_d.endOf('isoWeek').format('YYYY-MM-DD'))

    date: ->
      @_d._d

    #aliases
    s: (format = 'YYYY-MM-DD') ->
      @toString(format)

    d: ->
      @date()