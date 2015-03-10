###
This module contains util methods, maybe these methods should be refactorized
Pre-requisites:
  * GoogieSpell
  * IntroJs
@see Lemonette.Module
@see GoogieSpell is part of Lemonette.
@see http://usablica.github.io/intro.js/ IntroJs 
###
class @Lemonette.UtilsModule extends Lemonette.Module
  ###
  Create Spellchecker object for an Input
  This decorates a TextArea with a link to check spell 
  @param [String] input the id of the html input tag
  @param [Object] options 
  @option options [String] server_url the url of spell endpoint
  @return [GoogieSpell] object
  ###
  SpellChecker: (input, options) ->
    if not GoogieSpell
      alert 'You must add lemonette.spell.js to use Utils.SpellChecker'
      return
    options = options || {}
    options.server_url = '/spell'
    s = new GoogieSpell(options)
    s.decorateTextarea input
    return s

  ###
    Convert seconds to an Object with hh, mm and ss.
    @param [Double] seconsd
    @return [Object] hash
    @option hash [String] hh  hours in 00 format.
    @option hash [String] mm  minutes in 00 format.
    @option hash [String] ss  seconds in 00 format.
    @example
      object = App.Utils.secondsToHHMMSS(3650)
      console.log object.hh # => "01"
      console.log object.mm # => "00"
      console.log object.ss # => "50"
  ###
  secondsToHHMMSS: (seconds) ->
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

  ###
    Convert minutes to String
    @param [Double] minutes
    @return [String] string with format "HH:MM"
  ###
  minutesToHHMM: (minutes) ->
    hhmmss = @secondsToHHMMSS(minutes * 60)
    "#{hhmmss.hh}:#{hhmmss.mm}"

  ###
    Convert minutes to Format
    @param [Double] minutes
    @param [String] format ex: "Hh Mm"
    @return [String] string with format "5h 10m"
  ###
  minutesToFormat: (minutes, format) ->
    hhmmss = @secondsToHHMMSS(minutes * 60)
    hh = "#{hhmmss.hh}"
    mm = "#{hhmmss.mm}"
    time_f = format.split(/(:|\s)/)
    hours_f = time_f.shift()
    minutes_f = time_f.pop()
    separator = time_f.join('')
    hours = @fixTimeAndFormat(hh, hours_f)
    minutes = @fixTimeAndFormat(mm, minutes_f)
    format = "#{hours.format}#{separator}#{minutes.format}"

    format.replace('%H', hours.time).replace('%M', minutes.time)

  ###
    @private
  ###
  fixTimeAndFormat: (time, format) ->
    if format.search(/0+\S/) != -1
      format = format.replace(/0/g, '') if time.length > 1
    else
      time = time.replace(/^0/, '')

    {time: time, format: format}

  ###
    Show context help. It must be in another place!!!
    @see http://usablica.github.io/intro.js/ IntroJs 
    @param [Integer] step help step for introJS Library
    @param [Boolean] force show help. Default: False
  ###
  showHelp: (step, force = false) ->
    return if @showing and not force
    return if $.cookie("visited#{step}") and not force
    guide = introJs();
    guide.setOptions({'disableInteraction': true})
    guide.goToStep(step).start()
    guide.onexit =>
      @showing = false
    $.cookie "visited#{step}", 1
    @showing = 1
