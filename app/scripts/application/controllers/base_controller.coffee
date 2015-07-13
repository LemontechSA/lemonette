###
@see http://marionettejs.com/docs/v2.4.0/marionette.controller.html Marionette.Controller
Base controller enables a single instance of each Controller to improve memory allocation.
The creation of an instance of BaseController needs pass through an instance of 
{Lemonette.ControllersModule} to ensure an instance of LemonetteApplication inside.
@example Create a instance of BaseController
  App = new Lemonette.Application
  controller = new App.Controllers.BaseController
###
class @Lemonette.BaseController extends Marionette.Controller
  ###
  @param [Object] options
  @option options [Marionette.Region] region: is the region where the main view is rendered, the default region
          is requested to AppInstance: App.request "default:region" 
  @option options [Boolean] loading: sets if you need to provide a generic view of "loading"
  @see http://marionettejs.com/docs/v2.4.0/marionette.region.html Marionette.Region
  ###
  constructor: (options = {}) ->
    @App = Lemonette.InstanceApp
    @region = options.region or @App.request "default:region"
    @_instance_id = _.uniqueId("controller")
    @App.execute "register:instance", @, @_instance_id
    super
  
  ###
  This override invokes the App.execute "unregister:instance"
  ###
  close: ->
    @App.execute "unregister:instance", @, @_instance_id
    super

  ###
  Show view in the current (or custom) region
  @param view [Lemonette.View] instance to show
  @param [Object] options
  @option options [Boolean] loading sets if you need to provide a generic view of "loading"
  @option options [Marionette.Region] region where we render the view
  @see http://marionettejs.com/docs/v2.4.0/marionette.region.html Marionette.Region
  ###
  show: (view, options = {}) ->
    _.defaults options,
      loading: false
      region: @region

    @_setMainView view
    @_manageView view, options

  ###
  @private
  the first view we show is always going to become the mainView of our
  controller (whether its a layout or another view type).  So if this
  *is* a layout, when we show other regions inside of that layout, we
  check for the existance of a mainView first, so our controller is only
  closed down when the original mainView is closed.
  ###
  _setMainView: (view) ->
    return if @_mainView
    @_mainView = view
    @listenTo view, "close", @close

  ###
  @private
  Decide whether to display the view or show another view while loading the model/collection
  ###
  _manageView: (view, options) ->
    if options.loading
      @App.execute "show:loading", view, options
    else
      options.region.show view

