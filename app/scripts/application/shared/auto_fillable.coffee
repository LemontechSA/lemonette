"use strict"
@App.module "Shared", (Shared, App, Backbone, Marionette, $, _) ->

  class Shared.AutoFillable

    fillRelation: (collection, field_id, relation_id, event, relation_id_value, options = {}) ->
      if typeof(collection) == 'string'
        collection = App.Models.collection(collection)

      collection[relation_id] = if event then $(event.target).val() else relation_id_value
      @fillSelect(collection, field_id, options)

    fillSelect: (collection, field_id, options = {}) ->
      options = $.extend({persistent: true, cache: true, prefill: true}, options)

      if typeof(collection) == 'string'
        collection = App.Models.collection(collection)

      url = if typeof collection.url == 'function' then collection.url() else collection.url

      if options.persistent && collection.fetchedUrl == url
        @createOptionsFromCollection(collection, field_id, options)
      else
        fetchSuccess = =>
          collection.fetchedUrl = url
          @createOptionsFromCollection(collection, field_id, options)
        if options.cache
          collection.cacheFetch(success: fetchSuccess, true)
        else
          collection.prefillFetch(
            prefill: options.prefill
            success: fetchSuccess
          , true)

    createOptionsFromCollection: (collection, field_id, options = {}) ->
      default_options =
        selected_value: null
        name_field: 'name'
        default_value: null
        persistent: true
      options = $.extend(default_options, options)

      values = []
      collection.each((m) ->
        if !options.filter || options.filter(m, collection)
          if typeof options.name_field == 'string'
            value = m.get(options.name_field)
          else
            value = options.name_field(m)
          value = { id: m.id, value: value }
          values.push value

          if typeof(options.default_value) == 'function' && options.default_value(m)
            options.default_value = m.id
      )
      @createOptions(field_id, values, options.selected_value, options.default_value, options)

    createOptions: (field_id, values, selected_value = null, default_value = null, options = {}) ->
      if _.keys(options).length is 0
        default_options =
          selected_value: null
          name_field: 'name'
          default_value: null
          persistent: true
        options = $.extend(default_options, options)

      if default_value == null && @default_values && @default_values[field_id]
        default_value = @default_values[field_id]
      if selected_value == null
        selected_value = if @model && (@model.id || @model.get(field_id)) then @model.get(field_id) else default_value
      #+'' porque coffee convierte el selected == key de abajo a un === y no toma los ids numericos
      selected_value += ''
      select = options.element || @$('#' + field_id)
      select = $('#' + field_id) if select.length == 0
      select.find('option').remove()
      select.append($('<option/>',
        val: ''
        text: 'Seleccione...'
      ))

      $.each(values, (index, value) ->
        attrs =
          val: value.id || index
          text: value.value || value
        if(parseInt(selected_value, 10) == parseInt(value.id || index, 10))
          attrs.selected = 'selected'

        select.append($('<option/>', attrs))
      )

      select.change()

    fillModel: (options = {}, skipValidation = false) ->
      model = options.model || @model
      inputs = options.inputs || @$('[name]')

      if !skipValidation && !@validateInputs(inputs)
        return null

      inputs.each ->
        field = $(this).attr('name')
        value = $(this).val()
        if value == '' && this.tagName == 'SELECT'
          value = null
        else if $(this).attr('type') == 'checkbox'
          value = $(this).is(':checked')
        else if $(this).data('datefield')
          date = $("[data-datefield=#{field}].datetime-date").val()
            .replace(/^(\d{1,2})\D(\d{1,2})\D(\d{4})$/, '$3-$2-$1')
            .split('-')
          time_elem = $("[data-datefield=#{field}].datetime-time")
          time = (time_elem.val() || time_elem.data('empty_time') || '00:00').split(':')
          value = new Date(date[0], date[1] - 1, date[2], time[0], time[1]).toISOString()

        if options.beforeSet
          ret = options.beforeSet(this, model, value, field)
          if !ret
            return true #continue
          if typeof ret == 'object'
            if ret.field
              field = ret.field
            if ret.value
              value = ret.value

        model.set(field, value)

        if options.afterSet
          options.afterSet(this, model, value, field)

      model