###
D a spiced Date
@example Using D
  App = new Lemonette.Application
  spicedDate = new App.DateHelper.D
  console.log d.isToday() # => true
  console.log d.toString() # => 2015-02-26
  console.log d.startOfWeek() # => 2015-02-23
  console.log d.endOfWeek() # => 2015-03-01
###
class @Lemonette.D
  ###
  @private
  ###
  _d: {}
  ###
  @param date [String] or [Date] or [moment] or nothing asumes (new Date())
  ###
  constructor: (date) ->
    @_d = moment(date) if date instanceof String or typeof date == 'string'
    @_d = moment(date) if date instanceof Date
    @_d = moment(new Date()) if !date
    @_d = date if date and typeof date._d == 'object'

  ###
  Format the date
  @param format [String] optional, ex: "YYYY-MM-DD"
  @return [String] ex: 2015-02-25
  ###
  toString: (format = 'YYYY-MM-DD') ->
    @_d.format(format)

  ###
  Test if date is today
  @return [Boolean] true: if is today, false:if is not today
  ###
  isToday: ->
    @_d.isSame(moment().format('YYYY-MM-DD'))

  ###
  Start of week starting with D Date. 
  @return [Lemonette.D] instance with first day of week 
  ###
  startOfWeek: ->
    new Lemonette.D(@_d.startOf('isoWeek').format('YYYY-MM-DD'))

  ###
  End of week starting with D Date. 
  @return [Lemonette.D] instance with end day of week 
  ###
  endOfWeek: ->
    new Lemonette.D(@_d.endOf('isoWeek').format('YYYY-MM-DD'))

  ###
  @return [Date] Javascript date object of D 
  ###
  date: ->
    @_d._d

  ###
  @param [String] Format
  @return [String] Alias of toString() method
  ###
  s: (format = 'YYYY-MM-DD') ->
    @toString(format)

  ###
  @return [Date] Alias of date() method
  ###
  d: ->
    @date()
