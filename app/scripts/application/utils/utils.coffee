"use strict"

@App.module "Utils", ((Utils, App, Backbone, Marionette, $, _, GoogieSpell, toastr, introJs) ->

  Utils.SpellChecker = (input, options) ->
    if not GoogieSpell
      alert 'You must add lemontend.spell.js to use Utils.SpellChecker'
      return
    options = options || {}
    options.server_url = '/spell'
    s = new GoogieSpell(options)
    s.decorateTextarea input
    return s

  Utils.secondsToHHMMSS = (seconds) ->
    hours = Math.floor(seconds / 3600)
    seconds %= 3600
    minutes = Math.floor(seconds / 60)
    seconds %= 60
    seconds = parseInt(seconds)
    hours = "0#{hours}" if hours < 10
    minutes = "0#{minutes}" if minutes < 10
    seconds = "0#{seconds}" if seconds < 10

    {
      hh: hours
      mm: minutes
      ss: seconds
    }

  Utils.minutesToHHMM = (minutes) ->
    hhmmss = Utils.secondsToHHMMSS(minutes * 60)
    "#{hhmmss.hh}:#{hhmmss.mm}"

  Utils.showHelp = (step, force = false) ->
    return if @showing and not force
    return if $.cookie("visited#{step}") and not force
    guide = introJs();
    guide.setOptions({'disableInteraction': true})
    guide.goToStep(step).start()
    guide.onexit =>
      @showing = false
    $.cookie "visited#{step}", 1
    @showing = 1

), GoogieSpell, toastr, introJs