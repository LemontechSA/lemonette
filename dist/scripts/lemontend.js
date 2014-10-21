(function() {
  (function(Backbone) {
    return _.extend(Backbone.Marionette.Application.prototype, {
      defaultData: {
        host: 'localct.dev',
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

}).call(this);
