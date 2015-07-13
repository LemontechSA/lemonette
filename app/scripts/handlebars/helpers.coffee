do (Handlebars, i18n, moment, accounting) ->

  # translation helper for templates, uses i18Next library
  Handlebars.registerHelper 't', (key) ->
    result = i18n.t(key)
    new Handlebars.SafeString(result)

  # date format helper with moment (TODO: another param with format)
  Handlebars.registerHelper 'dt', (field, format, element) ->
    new Handlebars.SafeString(moment(element[field]).format(format))

  # convert duration (in minutes) to HH:MM
  Handlebars.registerHelper 'hm', (field, element) ->
    new Handlebars.SafeString(moment().startOf('day').add(parseInt(element[field]), "m").format("HH:mm"))

  # render partial, better method that original
  Handlebars.registerHelper 'p', (partial, element) ->
    new Handlebars.SafeString(JST[partial](element))

  # render input helpers
  Handlebars.registerHelper 'input', (partial, element) ->
    element = element.hash if element.hash
    element.wrapper_class = 'sm-2' if !element.wrapper_class
    if element.type == 'select'
      element.collection.fetch()
    new Handlebars.SafeString(JST['shared/inputs/' + partial](element))

  # Money format helper with accountingjs
  # amount = some number that is going to be formatted as money
  # format = hash {
  #   symbol: Character used as a currency symbol
  #   decimal: Character used as decimal separator
  #   thousand: Character used as thousands separator
  #   precision: How much decimals are significative
  #   format: Currency format for final string
  # }
  # Example:
  #   format = {
  #     symbol: '$',
  #     decimal: ',',
  #     thousand: '.',
  #     precision: 2,
  #     format: "%u %n"
  #   }
  #   {{formatMoney 123456.78 format}}
  #   $ 123.456,78
  #
  Handlebars.registerHelper 'formatMoney', (amount, format) ->
    new Handlebars.SafeString(accounting.formatMoney(amount, format))

  # Number format helper with accountingjs
  # number = some number that is going to be formatted as money
  # format = hash {
  #   precision: How much decimals are significative
  #   decimal: Character used as decimal separator
  #   thousand: Character used as thousands separator
  # }
  # Example:
  #   format = {
  #     decimal: ',',
  #     thousand: '.',
  #     precision: 2,
  #   }
  #   {{formatNumber 123456.78 format}}
  #   123.456,78
  #
  Handlebars.registerHelper 'formatNumber', (number, format) ->
    new Handlebars.SafeString(accounting.formatNumber(number, format))
