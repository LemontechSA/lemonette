
class @Lemonette.Module extends Marionette.Module
  initialize: (options, module, app) ->
    module.App = app;
    @App = app;
    Lemonette.InstanceApp = app;