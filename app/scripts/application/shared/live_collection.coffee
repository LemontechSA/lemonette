"use strict"
@App.module "Shared", (Shared, App, Backbone, Marionette, $, _) ->

  UpdateEventListener = (outstandingId, models) ->
    @_outstandingId = outstandingId
    @_awaitCount = models.length
    _.each models, ((model) ->
      @listenToOnce model, "sync error", @_onModelSync
    ), this

  _.extend UpdateEventListener::, Backbone.Events,
    _onModelSync: (model) ->
      if model.id is @_outstandingId

        # Great, this is the model we're waiting for!
        @trigger "found", model
        @stopListening()
      else if --@_awaitCount is 0

        # All the models are done and we haven't found the id we received from the realtime stream
        @stopListening()
        @trigger "notfound"

  class Shared.LiveCollection extends Backbone.Collection
    constructor: (models, options) ->
      Backbone.Collection::constructor.call this, models, options
      @subscription = App.fayeClient.subscribe(@channel, @_fayeEvent, this) if App.fayeClient

    _fayeEvent: (message) ->
      method = message.method
      body = message.body
      switch method
        when "POST"
          @_createEvent body
        when "PUT"
          @_updateEvent body
        when "DELETE"
          @_removeEvent body
        else
          console.log "Unknown realtime event", message

    _createEvent: (body) ->
      console.log "live: Create event", body

      # Does this id exist in the collection already?
      # If so, rather just do an update
      id = @_getModelId(body)
      return @_updateEvent(body)  if @get(id)

      # Look to see if this collection has any outstanding creates...
      idAttribute = @model::idAttribute
      unsaved = @filter((model) ->
        not model.id
      )

      # If there are unsaved items, monitor them and if one of them turns out to be the matching object
      # then simply update that
      if unsaved.length
        console.log "live: awaiting syncs of unsaved objects"
        listener = new UpdateEventListener(id, unsaved)
        listener.once "notfound", (->
          @add body,
            parse: true

        ), this
      else
        console.log "live: adding immediately"
        @add body,
          parse: true


    _updateEvent: (body) ->
      console.log "live: Update event", body
      id = @_getModelId(body)
      parsed = new @model(body,
        parse: true
      )

      # Try find an existing instance with the given ID
      existingModel = @get(id)

      # If it exists, update it
      if existingModel
        existingModel.set parsed.attributes
      else

        # If it doesn't exist, add it
        @add parsed

    _removeEvent: (body) ->
      console.log "live: Remove event", body
      id = @_getModelId(body)
      @remove id

    _getModelId: (model) ->
      model[@model::idAttribute]