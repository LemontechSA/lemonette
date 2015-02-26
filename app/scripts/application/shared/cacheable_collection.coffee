###
Backbone.Collection extension to store a collection in localStorage.

This collection is synced with server everytime, 
but only get differences between localStorage and ApiResult.
This collection add a posfix to endpoint url: "/updated?ts=" + (cacheTime) 
to request for only new records
@example

   class Currencies extends Backbone.Collection
      @include App.Shared.CacheableCollection
      url: '/currencies'
      model: Models.Currency

###
class @Lemonette.CacheableCollection extends Backbone.Collection    
  initialize : ->
    @removedItems = {}
    @on 'remove', (model) =>
      if model.id
        @removedItems[model.id] = model

  syncItems : (callback = undefined) ->
    $.each @removedItems, (id, model) =>
      model.urlRoot = @url()
      model.destroy()
    @removedItems = {}

    @each (model) =>
      if model.id
        model.save()
      else
        options = {}
        if $.isFunction(callback)
          options =
            success: callback
        @create(model, options)

    @

  #a diferencia del fetch(cache:true), aunque este cacheado igual se actualiza la coleccion
  prefillFetch : (options = {}, fireBothSuccesses) ->
    sucessFired = false
    prefillOptions = $.extend({prefill: true, expires: 30*24*60*60}, options)
    if options.success
      prefillOptions.prefillSuccess = (collection, data, opts) ->
        sucessFired = true
        options.success(collection, data, opts)
      prefillOptions.success = (collection, data, opts) ->
        if fireBothSuccesses || !sucessFired
          options.success(collection, data, opts)
    @fetch(prefillOptions)

  #si tiene cache, usa los datos cacheados, fetchea solo la diferencia, y actualiza la coleccion y el cache
  cacheFetch : (options = {}, fireBothSuccesses) =>
    cacheOptions = $.extend({cache: true, expires: 30*24*60*60}, options)
    cacheTime = @cacheTime()
    @fetch(cacheOptions)
    if cacheTime
      url = if typeof @url == 'function' then @url() else @url
      url += '/updated?ts=' + (cacheTime / 1000.0)
      url += '&' + @query() if @query and typeof @query == 'function'
      $.ajax(url,
        success: (data) =>
          @set(data.results, {add: true, merge: true, remove: false});
          @remove(@filter((model) ->
            data.ids.indexOf(model.id) < 0
          ))

          executeSuccess = =>
            @updateCache({expires: cacheOptions.expires})
            if options.success && fireBothSuccesses
              options.success(@, data, options)

          #si por alguna razon desaparecieron algunos o todos, refetchear
          if @length < data.ids.length
            @fetch success: ->
              executeSuccess()
          else
            executeSuccess()
      )

  resetFetched : (data) ->
    @reset(data)
    @fetchedUrl = @url