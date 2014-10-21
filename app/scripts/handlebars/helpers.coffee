do (Handlebars, i18n, moment) ->

  # translation helper for templates, uses i18Next library
  Handlebars.registerHelper 't', (key) ->
    result = i18n.t(key)
    return new Handlebars.SafeString(result)

  # date format helper with moment (TODO: another param with format)
  Handlebars.registerHelper 'dt', (field, format, element) ->
    return new Handlebars.SafeString(moment(element[field]).format(format))

  # convert duration (in minutes) to HH:MM
  Handlebars.registerHelper 'hm', (field, element) ->
    return new Handlebars.SafeString(moment().startOf('day').add(parseInt(element[field]), "m").format("HH:mm"))

  # render partial, better method that original
  Handlebars.registerHelper 'p', (partial, element) ->
    return new Handlebars.SafeString(JST[partial](element))

  # render input helpers
  Handlebars.registerHelper 'input', (partial, element) ->
    element = element.hash if element.hash
    element.wrapper_class = 'sm-2' if !element.wrapper_class
    if element.type == 'select'
      element.collection.fetch()
    return new Handlebars.SafeString(JST['shared/inputs/' + partial](element))
