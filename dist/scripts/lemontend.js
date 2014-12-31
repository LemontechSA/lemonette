(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.LemontendApp = this.App = (function(Marionette) {
    var App;
    App = new Marionette.Application();
    return App;
  })(Marionette);

  Function.prototype.include = function(mixin) {
    var key, value, _ref;
    _ref = mixin.prototype;
    for (key in _ref) {
      value = _ref[key];
      this.prototype[key] = value;
    }
    return this;
  };

  (function(Backbone) {
    return _.extend(Backbone.Marionette.Application.prototype, {
      defaultData: {
        host: 'localhost',
        api_url: 'http://localhost:3000',
        ws_endpoint: 'http://localhost:3000/faye',
        current_user: null,
        api_token: null,
        default_lang: 'es'
      },
      bootstrap: function(key) {
        var data;
        data = window.bootstrap_data || this.defaultData;
        return data[key];
      },
      navigate: function(route, options) {
        if (options == null) {
          options = {};
        }
        return Backbone.history.navigate(route, options);
      },
      getCurrentRoute: function() {
        var frag;
        frag = Backbone.history.fragment;
        if (_.isEmpty(frag)) {
          return null;
        } else {
          return frag;
        }
      },
      startHistory: function() {
        if (Backbone.history) {
          return Backbone.history.start();
        }
      },
      register: function(instance, id) {
        if (this._registry == null) {
          this._registry = {};
        }
        return this._registry[id] = instance;
      },
      unregister: function(instance, id) {
        return delete this._registry[id];
      },
      resetRegistry: function() {
        var controller, key, msg, oldCount, _ref;
        oldCount = this.getRegistrySize();
        _ref = this._registry;
        for (key in _ref) {
          controller = _ref[key];
          controller.region.close();
        }
        msg = "There were " + oldCount + " controllers in the registry, there are now " + (this.getRegistrySize());
        if (this.getRegistrySize() > 0) {
          return console.warn(msg, this._registry);
        } else {
          return console.log(msg);
        }
      },
      getRegistrySize: function() {
        return _.size(this._registry);
      },
      log: function() {
        return function(message, domain, level) {
          if (this.debug && this.debug < level) {
            return;
          }
          if (typeof message !== "string") {
            return console.log("Object(" + domain + ")", message);
          } else {
            return console.log((domain || false ? "(" + domain + ") " : "") + message);
          }
        };
      }
    });
  })(Backbone);

  (function(root, factory) {
    if (typeof define === "function" && define.amd) {
      define(["underscore", "backbone"], function(_, Backbone) {
        return root.Backbone = factory(_, Backbone);
      });
    } else {
      root.Backbone = factory(root._, root.Backbone);
    }
  })(this, function(_, Backbone) {
    var clearItem, createdTime, getCache, getLocalStorage, setCache, setLocalStorage, superMethods, supportLocalStorage, updateCache;
    setCache = function(instance, opts, attrs) {
      var expires, url;
      opts = opts || {};
      url = (_.isFunction(instance.url) ? instance.url() : instance.url);
      expires = false;
      if (!url) {
        return;
      }
      if (opts.cache === false) {
        return;
      }
      if (!(opts.cache || opts.prefill)) {
        return;
      }
      if (opts.expires !== false) {
        expires = (new Date()).getTime() + ((opts.expires || 5 * 60) * 1000);
      }
      Backbone.fetchCache._cache[url] = {
        created: new Date().getTime(),
        expires: expires,
        value: attrs
      };
      Backbone.fetchCache.setLocalStorage();
    };
    getCache = function(instance) {
      var url;
      url = (_.isFunction(instance.url) ? instance.url() : instance.url);
      if (url) {
        return Backbone.fetchCache._cache[url];
      } else {
        return null;
      }
    };
    updateCache = function(instance, opts, attrs) {
      var data;
      opts = opts || {};
      opts.cache = true;
      data = getCache(instance);
      if (data && !opts.hasOwnProperty("expires")) {
        opts.expires = (data.expires ? (data.expires - data.created) / 1000 : false);
      }
      setCache(instance, opts, attrs);
    };
    createdTime = function(instance) {
      var data;
      data = getCache(instance);
      if (data) {
        return data.created;
      } else {
        return null;
      }
    };
    clearItem = function(key) {
      delete Backbone.fetchCache._cache[key];
      Backbone.fetchCache.setLocalStorage();
    };
    setLocalStorage = function() {
      var code, err;
      if (!supportLocalStorage || !Backbone.fetchCache.localStorage) {
        return;
      }
      try {
        localStorage.setItem("backboneCache", JSON.stringify(Backbone.fetchCache._cache));
      } catch (_error) {
        err = _error;
        code = err.code || err.number || err.message;
        if (code === 22) {
          this._deleteCacheWithPriority();
        } else {
          throw err;
        }
      }
    };
    getLocalStorage = function() {
      var json;
      if (!supportLocalStorage || !Backbone.fetchCache.localStorage) {
        return;
      }
      json = localStorage.getItem("backboneCache") || "{}";
      Backbone.fetchCache._cache = JSON.parse(json);
    };
    superMethods = {
      modelFetch: Backbone.Model.prototype.fetch,
      modelSync: Backbone.Model.prototype.sync,
      collectionFetch: Backbone.Collection.prototype.fetch
    };
    supportLocalStorage = typeof window.localStorage !== "undefined";
    Backbone.fetchCache = Backbone.fetchCache || {};
    Backbone.fetchCache._cache = Backbone.fetchCache._cache || {};
    Backbone.fetchCache.priorityFn = function(a, b) {
      if (!a || !a.expires || !b || !b.expires) {
        return a;
      }
      return a.expires - b.expires;
    };
    Backbone.fetchCache._prioritize = function() {
      var index, sorted;
      sorted = _.values(this._cache).sort(this.priorityFn);
      index = _.indexOf(_.values(this._cache), sorted[0]);
      return _.keys(this._cache)[index];
    };
    Backbone.fetchCache._deleteCacheWithPriority = function() {
      Backbone.fetchCache._cache[this._prioritize()] = null;
      delete Backbone.fetchCache._cache[this._prioritize()];
      Backbone.fetchCache.setLocalStorage();
    };
    if (typeof Backbone.fetchCache.localStorage === "undefined") {
      Backbone.fetchCache.localStorage = true;
    }
    Backbone.Model.prototype.cacheTime = function() {
      return createdTime(this);
    };
    Backbone.Collection.prototype.cacheTime = function() {
      return createdTime(this);
    };
    Backbone.Model.prototype.updateCache = function(opts) {
      updateCache(this, opts, this.attributes);
    };
    Backbone.Collection.prototype.updateCache = function(opts) {
      updateCache(this, opts, _.map(this.models, function(m) {
        return m.attributes;
      }));
    };
    Backbone.Model.prototype.fetch = function(opts) {
      var attributes, data, expired, promise, url;
      opts = opts || {};
      url = (_.isFunction(this.url) ? this.url() : this.url);
      data = Backbone.fetchCache._cache[url];
      expired = false;
      attributes = false;
      promise = new $.Deferred();
      if (data) {
        expired = data.expires;
        expired = expired && data.expires < (new Date()).getTime();
        attributes = data.value;
      }
      if (!expired && (opts.cache || opts.prefill) && attributes) {
        this.set(this.parse(attributes), opts);
        if (_.isFunction(opts.prefillSuccess)) {
          opts.prefillSuccess(this, attributes, opts);
        }
        this.trigger("cachesync", this, attributes, opts);
        this.trigger("sync", this, attributes, opts);
        if (opts.prefill) {
          promise.notify(this);
        } else {
          if (_.isFunction(opts.success)) {
            opts.success(this);
          }
          return promise.resolve(this);
        }
      }
      superMethods.modelFetch.apply(this, arguments).done(_.bind(promise.resolve, this, this)).done(_.bind(Backbone.fetchCache.setCache, null, this, opts)).fail(_.bind(promise.reject, this, this));
      return promise;
    };
    Backbone.Model.prototype.sync = function(method, model, options) {
      var collection, i, keys, len;
      if (method === "read") {
        return superMethods.modelSync.apply(this, arguments);
      }
      collection = model.collection;
      keys = [];
      i = void 0;
      len = void 0;
      keys.push((_.isFunction(model.url) ? model.url() : model.url));
      if (!!collection) {
        keys.push((_.isFunction(collection.url) ? collection.url() : collection.url));
      }
      i = 0;
      len = keys.length;
      while (i < len) {
        clearItem(keys[i]);
        i++;
      }
      return superMethods.modelSync.apply(this, arguments);
    };
    Backbone.Collection.prototype.fetch = function(opts) {
      var attributes, data, expired, promise, url;
      opts = opts || {};
      url = (_.isFunction(this.url) ? this.url() : this.url);
      data = Backbone.fetchCache._cache[url];
      expired = false;
      attributes = false;
      promise = new $.Deferred();
      if (data) {
        expired = data.expires;
        expired = expired && data.expires < (new Date()).getTime();
        attributes = data.value;
      }
      if (!expired && (opts.cache || opts.prefill) && attributes) {
        this[(opts.reset ? "reset" : "set")](this.parse(attributes), opts);
        if (_.isFunction(opts.prefillSuccess)) {
          opts.prefillSuccess(this, attributes, opts);
        }
        this.trigger("cachesync", this, attributes, opts);
        this.trigger("sync", this, attributes, opts);
        if (opts.prefill) {
          promise.notify(this);
        } else {
          if (_.isFunction(opts.success)) {
            opts.success(this);
          }
          return promise.resolve(this);
        }
      }
      superMethods.collectionFetch.apply(this, arguments).done(_.bind(promise.resolve, this, this)).done(_.bind(Backbone.fetchCache.setCache, null, this, opts)).fail(_.bind(promise.reject, this, this));
      return promise;
    };
    getLocalStorage();
    Backbone.fetchCache._superMethods = superMethods;
    Backbone.fetchCache.setCache = setCache;
    Backbone.fetchCache.clearItem = clearItem;
    Backbone.fetchCache.setLocalStorage = setLocalStorage;
    Backbone.fetchCache.getLocalStorage = getLocalStorage;
    return Backbone;
  });

  (function(Handlebars, i18n, moment) {
    Handlebars.registerHelper('t', function(key) {
      var result;
      result = i18n.t(key);
      return new Handlebars.SafeString(result);
    });
    Handlebars.registerHelper('dt', function(field, format, element) {
      return new Handlebars.SafeString(moment(element[field]).format(format));
    });
    Handlebars.registerHelper('hm', function(field, element) {
      return new Handlebars.SafeString(moment().startOf('day').add(parseInt(element[field]), "m").format("HH:mm"));
    });
    Handlebars.registerHelper('p', function(partial, element) {
      return new Handlebars.SafeString(JST[partial](element));
    });
    return Handlebars.registerHelper('input', function(partial, element) {
      if (element.hash) {
        element = element.hash;
      }
      if (!element.wrapper_class) {
        element.wrapper_class = 'sm-2';
      }
      if (element.type === 'select') {
        element.collection.fetch();
      }
      return new Handlebars.SafeString(JST['shared/inputs/' + partial](element));
    });
  })(Handlebars, i18n, moment);

  "use strict";

  this.App.module("Ajax", function(Ajax, App, Backbone, Marionette, $, _) {
    return $(document).ajaxError(function(event, jqXHR, ajaxSettings, thrownError) {
      try {
        if (jqXHR.status > 400) {
          return App.execute('alert.show', {
            title: 'No autorizado',
            message: JSON.parse(jqXHR.responseText).message
          });
        }
      } catch (_error) {
        return console.log('Ajax Error');
      }
    });
  });

  "use strict";

  this.App.module("Shared", function(Shared, App, Backbone, Marionette, $, _) {
    return Shared.AutoFillable = (function() {
      function AutoFillable() {}

      AutoFillable.prototype.fillRelation = function(collection, field_id, relation_id, event, relation_id_value, options) {
        if (options == null) {
          options = {};
        }
        if (typeof collection === 'string') {
          collection = App.Models.collection(collection);
        }
        collection[relation_id] = event ? $(event.target).val() : relation_id_value;
        return this.fillSelect(collection, field_id, options);
      };

      AutoFillable.prototype.fillSelect = function(collection, field_id, options) {
        var fetchSuccess, url;
        if (options == null) {
          options = {};
        }
        options = $.extend({
          persistent: true,
          cache: true,
          prefill: true
        }, options);
        if (typeof collection === 'string') {
          collection = App.Models.collection(collection);
        }
        url = typeof collection.url === 'function' ? collection.url() : collection.url;
        if (options.persistent && collection.fetchedUrl === url) {
          return this.createOptionsFromCollection(collection, field_id, options);
        } else {
          fetchSuccess = (function(_this) {
            return function() {
              collection.fetchedUrl = url;
              return _this.createOptionsFromCollection(collection, field_id, options);
            };
          })(this);
          if (options.cache) {
            return collection.cacheFetch({
              success: fetchSuccess
            }, true);
          } else {
            return collection.prefillFetch({
              prefill: options.prefill,
              success: fetchSuccess
            }, true);
          }
        }
      };

      AutoFillable.prototype.createOptionsFromCollection = function(collection, field_id, options) {
        var default_options, values;
        if (options == null) {
          options = {};
        }
        default_options = {
          selected_value: null,
          name_field: 'name',
          default_value: null,
          persistent: true
        };
        options = $.extend(default_options, options);
        values = [];
        collection.each(function(m) {
          var value;
          if (!options.filter || options.filter(m, collection)) {
            if (typeof options.name_field === 'string') {
              value = m.get(options.name_field);
            } else {
              value = options.name_field(m);
            }
            value = {
              id: m.id,
              value: value
            };
            values.push(value);
            if (typeof options.default_value === 'function' && options.default_value(m)) {
              return options.default_value = m.id;
            }
          }
        });
        return this.createOptions(field_id, values, options.selected_value, options.default_value, options);
      };

      AutoFillable.prototype.createOptions = function(field_id, values, selected_value, default_value, options) {
        var default_options, select;
        if (selected_value == null) {
          selected_value = null;
        }
        if (default_value == null) {
          default_value = null;
        }
        if (options == null) {
          options = {};
        }
        if (_.keys(options).length === 0) {
          default_options = {
            selected_value: null,
            name_field: 'name',
            default_value: null,
            persistent: true
          };
          options = $.extend(default_options, options);
        }
        if (default_value === null && this.default_values && this.default_values[field_id]) {
          default_value = this.default_values[field_id];
        }
        if (selected_value === null) {
          selected_value = this.model && (this.model.id || this.model.get(field_id)) ? this.model.get(field_id) : default_value;
        }
        selected_value += '';
        select = options.element || this.$('#' + field_id);
        if (select.length === 0) {
          select = $('#' + field_id);
        }
        select.find('option').remove();
        select.append($('<option/>', {
          val: '',
          text: ''
        }));
        $.each(values, function(index, value) {
          var attrs;
          attrs = {
            val: value.id || index,
            text: value.value || value
          };
          if (parseInt(selected_value, 10) === parseInt(value.id || index, 10)) {
            attrs.selected = 'selected';
          }
          return select.append($('<option/>', attrs));
        });
        return select.change();
      };

      AutoFillable.prototype.fillModel = function(options, skipValidation) {
        var inputs, model;
        if (options == null) {
          options = {};
        }
        if (skipValidation == null) {
          skipValidation = false;
        }
        model = options.model || this.model;
        inputs = options.inputs || this.$('[name]');
        if (!skipValidation && !this.validateInputs(inputs)) {
          return null;
        }
        inputs.each(function() {
          var date, field, ret, time, time_elem, value;
          field = $(this).attr('name');
          value = $(this).val();
          if (value === '' && this.tagName === 'SELECT') {
            value = null;
          } else if ($(this).attr('type') === 'checkbox') {
            value = $(this).is(':checked');
          } else if ($(this).data('datefield')) {
            date = $("[data-datefield=" + field + "].datetime-date").val().replace(/^(\d{1,2})\D(\d{1,2})\D(\d{4})$/, '$3-$2-$1').split('-');
            time_elem = $("[data-datefield=" + field + "].datetime-time");
            time = (time_elem.val() || time_elem.data('empty_time') || '00:00').split(':');
            value = new Date(date[0], date[1] - 1, date[2], time[0], time[1]).toISOString();
          }
          if (options.beforeSet) {
            ret = options.beforeSet(this, model, value, field);
            if (!ret) {
              return true;
            }
            if (typeof ret === 'object') {
              if (ret.field) {
                field = ret.field;
              }
              if (ret.value) {
                value = ret.value;
              }
            }
          }
          model.set(field, value);
          if (options.afterSet) {
            return options.afterSet(this, model, value, field);
          }
        });
        return model;
      };

      return AutoFillable;

    })();
  });

  "use strict";

  this.App.module("Shared", function(Shared, App, Backbone, Marionette, $, _) {
    return Shared.CacheableCollection = (function(_super) {
      __extends(CacheableCollection, _super);

      function CacheableCollection() {
        this.cacheFetch = __bind(this.cacheFetch, this);
        return CacheableCollection.__super__.constructor.apply(this, arguments);
      }

      CacheableCollection.prototype.initialize = function() {
        this.removedItems = {};
        return this.on('remove', (function(_this) {
          return function(model) {
            if (model.id) {
              return _this.removedItems[model.id] = model;
            }
          };
        })(this));
      };

      CacheableCollection.prototype.syncItems = function(callback) {
        if (callback == null) {
          callback = void 0;
        }
        $.each(this.removedItems, (function(_this) {
          return function(id, model) {
            model.urlRoot = _this.url();
            return model.destroy();
          };
        })(this));
        this.removedItems = {};
        this.each((function(_this) {
          return function(model) {
            var options;
            if (model.id) {
              return model.save();
            } else {
              options = {};
              if ($.isFunction(callback)) {
                options = {
                  success: callback
                };
              }
              return _this.create(model, options);
            }
          };
        })(this));
        return this;
      };

      CacheableCollection.prototype.prefillFetch = function(options, fireBothSuccesses) {
        var prefillOptions, sucessFired;
        if (options == null) {
          options = {};
        }
        sucessFired = false;
        prefillOptions = $.extend({
          prefill: true,
          expires: 30 * 24 * 60 * 60
        }, options);
        if (options.success) {
          prefillOptions.prefillSuccess = function(collection, data, opts) {
            sucessFired = true;
            return options.success(collection, data, opts);
          };
          prefillOptions.success = function(collection, data, opts) {
            if (fireBothSuccesses || !sucessFired) {
              return options.success(collection, data, opts);
            }
          };
        }
        return this.fetch(prefillOptions);
      };

      CacheableCollection.prototype.cacheFetch = function(options, fireBothSuccesses) {
        var cacheOptions, cacheTime, url;
        if (options == null) {
          options = {};
        }
        cacheOptions = $.extend({
          cache: true,
          expires: 30 * 24 * 60 * 60
        }, options);
        cacheTime = this.cacheTime();
        this.fetch(cacheOptions);
        if (cacheTime) {
          url = typeof this.url === 'function' ? this.url() : this.url;
          url += '/updated?ts=' + (cacheTime / 1000.0);
          if (this.query && typeof this.query === 'function') {
            url += '&' + this.query();
          }
          return $.ajax(url, {
            success: (function(_this) {
              return function(data) {
                var executeSuccess;
                _this.set(data.results, {
                  add: true,
                  merge: true,
                  remove: false
                });
                _this.remove(_this.filter(function(model) {
                  return data.ids.indexOf(model.id) < 0;
                }));
                executeSuccess = function() {
                  _this.updateCache({
                    expires: cacheOptions.expires
                  });
                  if (options.success && fireBothSuccesses) {
                    return options.success(_this, data, options);
                  }
                };
                if (_this.length < data.ids.length) {
                  return _this.fetch({
                    success: function() {
                      return executeSuccess();
                    }
                  });
                } else {
                  return executeSuccess();
                }
              };
            })(this)
          });
        }
      };

      CacheableCollection.prototype.resetFetched = function(data) {
        this.reset(data);
        return this.fetchedUrl = this.url;
      };

      return CacheableCollection;

    })(Backbone.Collection);
  });

  "use strict";

  this.App.module("Shared", function(Shared, App, Backbone, Marionette, $, _) {
    var UpdateEventListener;
    UpdateEventListener = function(outstandingId, models) {
      this._outstandingId = outstandingId;
      this._awaitCount = models.length;
      return _.each(models, (function(model) {
        return this.listenToOnce(model, "sync error", this._onModelSync);
      }), this);
    };
    _.extend(UpdateEventListener.prototype, Backbone.Events, {
      _onModelSync: function(model) {
        if (model.id === this._outstandingId) {
          this.trigger("found", model);
          return this.stopListening();
        } else if (--this._awaitCount === 0) {
          this.stopListening();
          return this.trigger("notfound");
        }
      }
    });
    return Shared.LiveCollection = (function(_super) {
      __extends(LiveCollection, _super);

      function LiveCollection(models, options) {
        Backbone.Collection.prototype.constructor.call(this, models, options);
        if (App.fayeClient) {
          this.subscription = App.fayeClient.subscribe(this.channel, this._fayeEvent, this);
        }
      }

      LiveCollection.prototype._fayeEvent = function(message) {
        var body, method;
        method = message.method;
        body = message.body;
        switch (method) {
          case "POST":
            return this._createEvent(body);
          case "PUT":
            return this._updateEvent(body);
          case "DELETE":
            return this._removeEvent(body);
          default:
            return console.log("Unknown realtime event", message);
        }
      };

      LiveCollection.prototype._createEvent = function(body) {
        var id, idAttribute, listener, unsaved;
        console.log("live: Create event", body);
        id = this._getModelId(body);
        if (this.get(id)) {
          return this._updateEvent(body);
        }
        idAttribute = this.model.prototype.idAttribute;
        unsaved = this.filter(function(model) {
          return !model.id;
        });
        if (unsaved.length) {
          console.log("live: awaiting syncs of unsaved objects");
          listener = new UpdateEventListener(id, unsaved);
          return listener.once("notfound", (function() {
            return this.add(body, {
              parse: true
            });
          }), this);
        } else {
          console.log("live: adding immediately");
          return this.add(body, {
            parse: true
          });
        }
      };

      LiveCollection.prototype._updateEvent = function(body) {
        var existingModel, id, parsed;
        console.log("live: Update event", body);
        id = this._getModelId(body);
        parsed = new this.model(body, {
          parse: true
        });
        existingModel = this.get(id);
        if (existingModel) {
          return existingModel.set(parsed.attributes);
        } else {
          return this.add(parsed);
        }
      };

      LiveCollection.prototype._removeEvent = function(body) {
        var id;
        console.log("live: Remove event", body);
        id = this._getModelId(body);
        return this.remove(id);
      };

      LiveCollection.prototype._getModelId = function(model) {
        return model[this.model.prototype.idAttribute];
      };

      return LiveCollection;

    })(Backbone.Collection);
  });

  "use strict";

  this.App.module("DateHelper", function(DateHelper, App, Backbone, Marionette, $, _) {
    return DateHelper.D = (function() {
      D.prototype._d = {};

      function D(date) {
        if (date instanceof String || typeof date === 'string') {
          this._d = moment(date);
        }
        if (date instanceof Date) {
          this._d = moment(date);
        }
        if (!date) {
          this._d = moment(new Date());
        }
        if (typeof date._d === 'object') {
          this._d = date;
        }
      }

      D.prototype.toString = function(format) {
        if (format == null) {
          format = 'YYYY-MM-DD';
        }
        return this._d.format(format);
      };

      D.prototype.isToday = function() {
        return this._d.isSame(moment().format('YYYY-MM-DD'));
      };

      D.prototype.startOfWeek = function() {
        return new DateHelper.D(this._d.startOf('isoWeek').format('YYYY-MM-DD'));
      };

      D.prototype.endOfWeek = function() {
        return new DateHelper.D(this._d.endOf('isoWeek').format('YYYY-MM-DD'));
      };

      D.prototype.date = function() {
        return this._d._d;
      };

      D.prototype.s = function(format) {
        if (format == null) {
          format = 'YYYY-MM-DD';
        }
        return this.toString(format);
      };

      D.prototype.d = function() {
        return this.date();
      };

      return D;

    })();
  });

  "use strict";

  this.App.module("Utils", (function(Utils, App, Backbone, Marionette, $, _, GoogieSpell, toastr, introJs) {
    Utils.SpellChecker = function(input, options) {
      var s;
      if (!GoogieSpell) {
        alert('You must add lemontend.spell.js to use Utils.SpellChecker');
        return;
      }
      options = options || {};
      options.server_url = '/spell';
      s = new GoogieSpell(options);
      s.decorateTextarea(input);
      return s;
    };
    Utils.secondsToHHMMSS = function(seconds) {
      var hours, minutes;
      hours = Math.floor(seconds / 3600);
      seconds %= 3600;
      minutes = Math.floor(seconds / 60);
      seconds %= 60;
      seconds = parseInt(seconds);
      if (hours < 10) {
        hours = "0" + hours;
      }
      if (minutes < 10) {
        minutes = "0" + minutes;
      }
      if (seconds < 10) {
        seconds = "0" + seconds;
      }
      return {
        hh: hours,
        mm: minutes,
        ss: seconds
      };
    };
    Utils.minutesToHHMM = function(minutes) {
      var hhmmss;
      hhmmss = Utils.secondsToHHMMSS(minutes * 60);
      return "" + hhmmss.hh + ":" + hhmmss.mm;
    };
    Utils.minutesToFormat = function(minutes, format) {
      var hh, hhmmss, hours, hours_f, minutes_f, mm, separator, time_f;
      hhmmss = Utils.secondsToHHMMSS(minutes * 60);
      hh = "" + hhmmss.hh;
      mm = "" + hhmmss.mm;
      time_f = format.split(/(:|\s)/);
      hours_f = time_f.shift();
      minutes_f = time_f.pop();
      separator = time_f.join('');
      hours = Utils.fixTimeAndFormat(hh, hours_f);
      minutes = Utils.fixTimeAndFormat(mm, minutes_f);
      format = "" + hours.format + separator + minutes.format;
      return format.replace('%H', hours.time).replace('%M', minutes.time);
    };
    Utils.fixTimeAndFormat = function(time, format) {
      if (format.search(/0+\S/) !== -1) {
        if (time.length > 1) {
          format = format.replace(/0/g, '');
        }
      } else {
        time = time.replace(/^0/, '');
      }
      return {
        time: time,
        format: format
      };
    };
    return Utils.showHelp = function(step, force) {
      var guide;
      if (force == null) {
        force = false;
      }
      if (this.showing && !force) {
        return;
      }
      if ($.cookie("visited" + step) && !force) {
        return;
      }
      guide = introJs();
      guide.setOptions({
        'disableInteraction': true
      });
      guide.goToStep(step).start();
      guide.onexit((function(_this) {
        return function() {
          return _this.showing = false;
        };
      })(this));
      $.cookie("visited" + step, 1);
      return this.showing = 1;
    };
  }), GoogieSpell, toastr, introJs);

  "use strict";

  this.App.module("Notifications", (function(Notifications, App, Backbone, Marionette, $, _, toastr) {
    var Toast;
    Notifications.addInitializer(function() {
      App.commands.setHandler('alert.show', function(options) {
        var opts;
        opts = {
          css: 'toast-top-full-width',
          type: options.type || 'warning',
          message: options.message || 'You must provide a message',
          success: options.success,
          showMethod: 'slideDown',
          title: options.title || "Información Importante"
        };
        $.extend(opts, options);
        return Notifications.showMessage(opts);
      });
      return App.commands.setHandler('info.show', function(options) {
        var opts;
        opts = {
          css: 'toast-top-full-width',
          type: options.type || 'info',
          message: options.message || 'You must provide a message',
          success: options.success
        };
        $.extend(opts, options);
        return Notifications.showMessage(opts);
      });
    });
    Toast = function(type, css, title, message) {
      this.type = type;
      this.css = css;
      this.message = message;
      this.title = title;
    };
    return Notifications.showMessage = function(options) {
      var t;
      if (options == null) {
        options = {};
      }
      t = new Toast(options.type, options.css, options.title, options.message);
      toastr.options.extendedTimeOut = 0;
      toastr.options.timeOut = options.timeOut || 5000;
      toastr.options.showMethod = options.showMethod || "slideDown";
      toastr.options.hideMethod = options.hideMethod || 'slideUp';
      toastr.options.hideDuration = 200;
      toastr.options.positionClass = t.css || "toast-top-full-width";
      toastr.options.onclick = function() {
        toastr.clear();
        if (options.onclick) {
          return options.onclick();
        }
      };
      toastr[t.type](t.message, t.title);
      return $('.toast .action').on('click', function() {
        var callback;
        toastr.clear();
        callback = $(this).data('callback');
        if (callback && options[callback]) {
          return options[callback]();
        }
      });
    };
  }), toastr);

  "use strict";

  this.App.module("Controllers", function(Controllers, App, Backbone, Marionette, $, _) {
    return Controllers.Base = (function(_super) {
      __extends(Base, _super);

      function Base(options) {
        if (options == null) {
          options = {};
        }
        this.region = options.region || App.request("default:region");
        this._instance_id = _.uniqueId("controller");
        App.execute("register:instance", this, this._instance_id);
        Base.__super__.constructor.apply(this, arguments);
      }

      Base.prototype.close = function() {
        App.execute("unregister:instance", this, this._instance_id);
        return Base.__super__.close.apply(this, arguments);
      };

      Base.prototype.show = function(view, options) {
        if (options == null) {
          options = {};
        }
        _.defaults(options, {
          loading: false,
          region: this.region
        });
        this._setMainView(view);
        return this._manageView(view, options);
      };

      Base.prototype._setMainView = function(view) {
        if (this._mainView) {
          return;
        }
        this._mainView = view;
        return this.listenTo(view, "close", this.close);
      };

      Base.prototype._manageView = function(view, options) {
        if (options.loading) {
          return App.execute("show:loading", view, options);
        } else {
          return options.region.show(view);
        }
      };

      return Base;

    })(Marionette.Controller);
  });

  "use strict";

  this.App.module("Routers", function(Routers, App, Backbone, Marionette, $, _) {
    return Routers.TrackableRouter = (function(_super) {
      __extends(TrackableRouter, _super);

      function TrackableRouter(options) {
        TrackableRouter.__super__.constructor.apply(this, arguments);
        this.on('route', function(page, options) {
          return ga('send', 'pageview', page, page);
        });
        return;
      }

      return TrackableRouter;

    })(Marionette.AppRouter);
  });

  this.App.module("Views", function(Views, App, Backbone, Marionette, $, _) {
    return Views.Trackable = (function() {
      function Trackable() {}

      Trackable.prototype.trackables = {};

      Trackable.prototype.trackingValues = {};

      Trackable.prototype.trackingLabels = {};

      Trackable.prototype.trackingNoninteractions = {};

      Trackable.prototype.pushEvent = function(event) {
        return this.trackEvent(event.category, event.action, event.label, event.value, event.noninteraction);
      };

      Trackable.prototype.trackEvent = function(category, action, opt_label, opt_value) {
        return ga('send', 'event', category, action, opt_label);
      };

      Trackable.prototype.setTrackingValue = function(action, value) {
        return this.trackingValues[action] = value;
      };

      Trackable.prototype.setTrackingLabel = function(action, label) {
        return this.trackingLabels[action] = label;
      };

      Trackable.prototype.setTrackingNoninteraction = function(action, noninteraction) {
        return this.trackingNoninteractions[action] = noninteraction;
      };

      Trackable.prototype.getSelector = function(event) {
        var selector;
        if (!event) {
          return '';
        }
        if (event.target && event.target && $(event.target).data('track')) {
          return $(event.target).data('track');
        }
        return selector = event.target.id ? '#' + event.target.id : event.target.tagName + ' ' + event.target.className;
      };

      Trackable.prototype.getValue = function(event) {
        if (event && event.target && event.target && $(event.target).data('track-value')) {
          return $(event.target).data('track-value');
        }
        return '';
      };

      Trackable.prototype.getEventName = function(event) {
        return (event ? event.type || '' : 'system');
      };

      Trackable.prototype.track = function(options) {
        var category, event_name, evt, selector;
        event_name = this.getEventName(options['event']);
        options['label'] = options['label'] || this.trackingLabels[options['action']];
        options['action'] = options['action'] || event_name;
        options['value'] = options['value'] || this.getValue(options['event']);
        selector = this.getSelector(options['event']);
        category = this.trackName || this.constructor.name;
        if (!options['label']) {
          options['label'] = "" + event_name + " " + selector;
        }
        evt = {
          category: category,
          action: options['action'],
          label: options['label'],
          value: options['value'] ? options['value'] : '',
          timestamp: Date.now()
        };
        return setTimeout((function(_this) {
          return function() {
            return _this.pushEvent(evt);
          };
        })(this));
      };

      return Trackable;

    })();
  });

  this.App.module("Views", function(Views, App, Backbone, Marionette, $, _) {
    return _.extend(Marionette.View.prototype, {
      genericThing: function() {
        return console.log('generic thing for views :)');
      }
    });
  });

  this.App.module("Views", function(Views, App, Backbone, Marionette, $, _) {
    return Views.CollectionView = (function(_super) {
      __extends(CollectionView, _super);

      function CollectionView() {
        return CollectionView.__super__.constructor.apply(this, arguments);
      }

      CollectionView.prototype.itemViewEventPrefix = "childview";

      return CollectionView;

    })(Marionette.CollectionView);
  });

  this.App.module("Views", function(Views, App, Backbone, Marionette, $, _) {
    return Views.CompositeView = (function(_super) {
      __extends(CompositeView, _super);

      function CompositeView() {
        return CompositeView.__super__.constructor.apply(this, arguments);
      }

      CompositeView.prototype.itemViewEventPrefix = "childview";

      CompositeView.prototype.onShow = function() {
        if (this.help_step > 0) {
          return App.Utils.showHelp(this.help_step);
        }
      };

      return CompositeView;

    })(Marionette.CompositeView);
  });

  this.App.module("Views", function(Views, App, Backbone, Marionette, $, _) {
    return Views.ItemView = (function(_super) {
      __extends(ItemView, _super);

      function ItemView() {
        return ItemView.__super__.constructor.apply(this, arguments);
      }

      ItemView.prototype.onShow = function() {
        if (this.help_step > 0) {
          return App.execute("help:show", this.help_step);
        }
      };

      return ItemView;

    })(Marionette.ItemView);
  });

  this.App.module("Views", function(Views, App, Backbone, Marionette, $, _) {
    return Views.Layout = (function(_super) {
      __extends(Layout, _super);

      function Layout() {
        return Layout.__super__.constructor.apply(this, arguments);
      }

      Views.BackboneView = (function(_super1) {
        __extends(BackboneView, _super1);

        function BackboneView() {
          return BackboneView.__super__.constructor.apply(this, arguments);
        }

        return BackboneView;

      })(Backbone.View);

      return Layout;

    })(Marionette.Layout);
  });

}).call(this);
