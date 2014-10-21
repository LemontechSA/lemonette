do (Backbone) ->

  _.extend Backbone.Marionette.Application::,

    defaultData:
      host: 'localhost'
      api_url: 'http://localhost:3000'
      ws_endpoint: 'http://localhost:3000/faye'
      current_user: null,
      api_token: null,
      default_lang: 'es'

    bootstrap: (key) ->
      data = window.bootstrap_data || @defaultData
      data[key]

    navigate: (route, options = {}) ->
      Backbone.history.navigate route, options

    getCurrentRoute: ->
      frag = Backbone.history.fragment
      if _.isEmpty(frag) then null else frag

    startHistory: ->
      if Backbone.history
        Backbone.history.start()

    register: (instance, id) ->
      @_registry ?= {}
      @_registry[id] = instance

    unregister: (instance, id) ->
      delete @_registry[id]

    resetRegistry: ->
      oldCount = @getRegistrySize()
      for key, controller of @_registry
        controller.region.close()
      msg = "There were #{oldCount} controllers in the registry, there are now #{@getRegistrySize()}"
      if @getRegistrySize() > 0 then console.warn(msg, @_registry) else console.log(msg)

    getRegistrySize: ->
      _.size @_registry

    log: -> (message, domain, level) ->
      return if @debug && @debug < level
      if typeof message isnt "string"
        console.log "Object(" + domain + ")", message
      else
        console.log ((if domain or false then "(" + domain + ") " else "")) + message

