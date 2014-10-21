#!
#  backbone.fetch-cache v0.1.9
#  by Andy Appleton - https://github.com/mrappleton/backbone-fetch-cache.git
# 

# AMD wrapper from https://github.com/umdjs/umd/blob/master/amdWebGlobal.js
((root, factory) ->
  if typeof define is "function" and define.amd
    
    # AMD. Register as an anonymous module and set browser global
    define [
      "underscore"
      "backbone"
    ], (_, Backbone) ->
      root.Backbone = factory(_, Backbone)

  else
    
    # Browser globals
    root.Backbone = factory(root._, root.Backbone)
  return
) this, (_, Backbone) ->
  
  # Setup
  
  # Shared methods
  setCache = (instance, opts, attrs) ->
    opts = (opts or {})
    url = (if _.isFunction(instance.url) then instance.url() else instance.url)
    expires = false
    
    # Need url to use as cache key so return if we can't get it
    return  unless url
    
    # Never set the cache if user has explicitly said not to
    return  if opts.cache is false
    
    # Don't set the cache unless cache: true or prefill: true option is passed
    return  unless opts.cache or opts.prefill
    expires = (new Date()).getTime() + ((opts.expires or 5 * 60) * 1000)  if opts.expires isnt false
    Backbone.fetchCache._cache[url] =
      created: new Date().getTime()
      expires: expires
      value: attrs

    Backbone.fetchCache.setLocalStorage()
    return
  getCache = (instance) ->
    url = (if _.isFunction(instance.url) then instance.url() else instance.url)
    (if url then Backbone.fetchCache._cache[url] else null)
  updateCache = (instance, opts, attrs) ->
    opts = (opts or {})
    opts.cache = true
    data = getCache(instance)
    opts.expires = (if data.expires then (data.expires - data.created) / 1000 else false)  if data and not opts.hasOwnProperty("expires")
    setCache instance, opts, attrs
    return
  createdTime = (instance) ->
    data = getCache(instance)
    (if data then data.created else null)
  clearItem = (key) ->
    delete Backbone.fetchCache._cache[key]

    Backbone.fetchCache.setLocalStorage()
    return
  setLocalStorage = ->
    return  if not supportLocalStorage or not Backbone.fetchCache.localStorage
    try
      localStorage.setItem "backboneCache", JSON.stringify(Backbone.fetchCache._cache)
    catch err
      code = err.code or err.number or err.message
      if code is 22
        @_deleteCacheWithPriority()
      else
        throw (err)
    return
  getLocalStorage = ->
    return  if not supportLocalStorage or not Backbone.fetchCache.localStorage
    json = localStorage.getItem("backboneCache") or "{}"
    Backbone.fetchCache._cache = JSON.parse(json)
    return
  superMethods =
    modelFetch: Backbone.Model::fetch
    modelSync: Backbone.Model::sync
    collectionFetch: Backbone.Collection::fetch

  supportLocalStorage = typeof window.localStorage isnt "undefined"
  Backbone.fetchCache = (Backbone.fetchCache or {})
  Backbone.fetchCache._cache = (Backbone.fetchCache._cache or {})
  Backbone.fetchCache.priorityFn = (a, b) ->
    return a  if not a or not a.expires or not b or not b.expires
    a.expires - b.expires

  Backbone.fetchCache._prioritize = ->
    sorted = _.values(@_cache).sort(@priorityFn)
    index = _.indexOf(_.values(@_cache), sorted[0])
    _.keys(@_cache)[index]

  Backbone.fetchCache._deleteCacheWithPriority = ->
    Backbone.fetchCache._cache[@_prioritize()] = null
    delete Backbone.fetchCache._cache[@_prioritize()]

    Backbone.fetchCache.setLocalStorage()
    return

  Backbone.fetchCache.localStorage = true  if typeof Backbone.fetchCache.localStorage is "undefined"
  
  # Instance methods
  Backbone.Model::cacheTime = ->
    createdTime this

  Backbone.Collection::cacheTime = ->
    createdTime this

  Backbone.Model::updateCache = (opts) ->
    updateCache this, opts, @attributes
    return

  Backbone.Collection::updateCache = (opts) ->
    updateCache this, opts, _.map(@models, (m) ->
      m.attributes
    )
    return

  Backbone.Model::fetch = (opts) ->
    opts = (opts or {})
    url = (if _.isFunction(@url) then @url() else @url)
    data = Backbone.fetchCache._cache[url]
    expired = false
    attributes = false
    promise = new $.Deferred()
    if data
      expired = data.expires
      expired = expired and data.expires < (new Date()).getTime()
      attributes = data.value
    if not expired and (opts.cache or opts.prefill) and attributes
      @set @parse(attributes), opts
      opts.prefillSuccess this, attributes, opts  if _.isFunction(opts.prefillSuccess)
      
      # Trigger sync events
      @trigger "cachesync", this, attributes, opts
      @trigger "sync", this, attributes, opts
      
      # Notify progress if we're still waiting for an AJAX call to happen...
      if opts.prefill
        promise.notify this
      
      # ...finish and return if we're not
      else
        opts.success this  if _.isFunction(opts.success)
        
        # Mimic actual fetch behaviour buy returning a fulfilled promise
        return promise.resolve(this)
    
    # Delegate to the actual fetch method and store the attributes in the cache
    
    # resolve the returned promise when the AJAX call completes
    
    # Set the new data in the cache
    
    # Reject the promise on fail
    superMethods.modelFetch.apply(this, arguments).done(_.bind(promise.resolve, this, this)).done(_.bind(Backbone.fetchCache.setCache, null, this, opts)).fail _.bind(promise.reject, this, this)
    
    # return a promise which provides the same methods as a jqXHR object
    promise

  
  # Override Model.prototype.sync and try to clear cache items if it looks
  # like they are being updated.
  Backbone.Model::sync = (method, model, options) ->
    
    # Only empty the cache if we're doing a create, update, patch or delete.
    return superMethods.modelSync.apply(this, arguments)  if method is "read"
    collection = model.collection
    keys = []
    i = undefined
    len = undefined
    
    # Build up a list of keys to delete from the cache, starting with this
    keys.push (if _.isFunction(model.url) then model.url() else model.url)
    
    # If this model has a collection, also try to delete the cache for that
    keys.push (if _.isFunction(collection.url) then collection.url() else collection.url)  unless not collection
    
    # Empty cache for all found keys
    i = 0
    len = keys.length

    while i < len
      clearItem keys[i]
      i++
    superMethods.modelSync.apply this, arguments

  Backbone.Collection::fetch = (opts) ->
    opts = (opts or {})
    url = (if _.isFunction(@url) then @url() else @url)
    data = Backbone.fetchCache._cache[url]
    expired = false
    attributes = false
    promise = new $.Deferred()
    if data
      expired = data.expires
      expired = expired and data.expires < (new Date()).getTime()
      attributes = data.value
    if not expired and (opts.cache or opts.prefill) and attributes
      this[(if opts.reset then "reset" else "set")] @parse(attributes), opts
      opts.prefillSuccess this, attributes, opts  if _.isFunction(opts.prefillSuccess)
      
      # Trigger sync events
      @trigger "cachesync", this, attributes, opts
      @trigger "sync", this, attributes, opts
      
      # Notify progress if we're still waiting for an AJAX call to happen...
      if opts.prefill
        promise.notify this
      
      # ...finish and return if we're not
      else
        opts.success this  if _.isFunction(opts.success)
        
        # Mimic actual fetch behaviour buy returning a fulfilled promise
        return promise.resolve(this)
    
    # Delegate to the actual fetch method and store the attributes in the cache
    
    # resolve the returned promise when the AJAX call completes
    
    # Set the new data in the cache
    
    # Reject the promise on fail
    superMethods.collectionFetch.apply(this, arguments).done(_.bind(promise.resolve, this, this)).done(_.bind(Backbone.fetchCache.setCache, null, this, opts)).fail _.bind(promise.reject, this, this)
    
    # return a promise which provides the same methods as a jqXHR object
    promise

  
  # Prime the cache from localStorage on initialization
  getLocalStorage()
  
  # Exports
  Backbone.fetchCache._superMethods = superMethods
  Backbone.fetchCache.setCache = setCache
  Backbone.fetchCache.clearItem = clearItem
  Backbone.fetchCache.setLocalStorage = setLocalStorage
  Backbone.fetchCache.getLocalStorage = getLocalStorage
  Backbone
