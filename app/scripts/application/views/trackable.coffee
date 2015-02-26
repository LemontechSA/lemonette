class @Lemonette.Trackable
  trackables: {}
  trackingValues: {}
  trackingLabels: {}
  trackingNoninteractions: {}

  pushEvent : (event) ->      
    @trackEvent(event.category, event.action, event.label, event.value, event.noninteraction)
     
  trackEvent: (category, action, opt_label, opt_value) ->
    ga('send', 'event', category, action, opt_label);
  
  setTrackingValue : (action, value) ->
    @trackingValues[action] = value

  setTrackingLabel : (action, label) ->
    @trackingLabels[action] = label

  setTrackingNoninteraction : (action, noninteraction) ->
    @trackingNoninteractions[action] = noninteraction

  getSelector: (event) ->
    return '' unless event
    return $(event.target).data('track') if event.target && event.target && $(event.target).data('track')
    selector = if event.target.id then '#' + event.target.id else event.target.tagName + ' ' + event.target.className

  getValue: (event) ->
    return $(event.target).data('track-value') if event && event.target && event.target && $(event.target).data('track-value')
    return '' 

  getEventName: (event) ->
    return (if event then event.type || '' else 'system')

  track: (options) ->
    event_name = @getEventName(options['event'])
    options['label'] = options['label'] || @trackingLabels[options['action']]
    options['action'] = options['action'] || event_name
    options['value'] = options['value'] || @getValue(options['event'])
    selector = @getSelector(options['event'])
    category = @trackName || @constructor.name
    if not options['label']
      options['label'] = "#{event_name} #{selector}"
    evt =
      category: category
      action: options['action']
      label: options['label']
      value: if options['value'] then options['value'] else ''
      timestamp: Date.now()
    setTimeout =>
      @pushEvent(evt)