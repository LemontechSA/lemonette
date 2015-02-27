Lemonette
=========

A Lemon spiced Marionette Application Library.

* npm install
* bower install
* grunt

Generate versions for distribution
----------------------------------

* grunt dist


Usage
-----

* Add to bower.json 

  "limonette": "git@bitbucket.org:lemontech/limonette.git#master"

* Bower Install 

* Add every prerequisite installed by Lemonette and the library

```
  <script src="bower_components/libraries.js"></script>
    <script src="bower_components/lemonette.spell.js"></script>
    <script src="bower_components/lemonette.js"></script>
    <script src="scripts/app.js"></script>
```

* In app.coffee:

```
  App = new Lemonette.Application()
  App.start()

```

Now your Marionette Application has the following Modules:

### Controllers
Base controllers with new methods:

  * show Method:
  
    ```
    class MyController extends App.Controllers.BaseController
      initialize: ->
        layout = new App.Views.ItemView()
        @show layout
    ```

### DateHelper
New Date Class with steroids

  * D: 
  
    ```
      d = new App.DateHelper.D()
      # d = new App.DateHelper.D(<Date>)
      console.log d.isToday() # => true
      console.log d.toString() # => 2015-02-26
      console.log d.startOfWeek() # => 2015-02-23
      console.log d.endOfWeek() # => 2015-03-01
    ```

### Notifications

  * ShowAlert: 
  
    ```
    App.execute 'alert.show', {title: 'No autorizado', message: 'No tienes los privilegios suficientes'
    ```
    
  * ShowInfo: 
  
    ```
    App.execute 'info.show', {title: 'Guardar Cliente', message: 'El Cliente ha sido actualizado con éxito'
    ```
### Routers
Spiced Routers

  * TrackableRouter: A router that sends pageview to GoogleAnalytics when a route is fired.
  
    ```
    class MyRoute extends App.Routres.TrackableRouter 
      appRoutes:
        "myroute":  "mymethod"
    ```

### Shared

  * **AutoFillable**: fill selects and models from a view
  * **CacheableCollection**: A Backbone.Collection with localStorage caché, but synced with server API.
  * **LiveCollection**: A Backbone.Collection with sync vía Websocket channel. 

### Utils

  * SpellChecker: ```speller = App.Utils.SpellChecker('description')```
  * secondsToHHMMSS: 
    
    ```
      object = App.Utils.secondsToHHMMSS(3650)
      console.log object.hh # => "01"
      console.log object.mm # => "00"
      console.log object.ss # => "50"
    ```
  * minutesToHHMM
  * minutesToFormat
  * showHelp: Show contextual help for a view.
  

### Views

* **Trackable**: send events to google analytics
* **Layout**
* **ItemView**
* **CollectionView**
* **CompositeView**
* **BackboneView** 

```
  class MyView extends App.Views.Trackable
    events:
      'click .search': 'search'
      'click .excel': 'excel'
      'click .edit' : 'editEvent'
    trackables:
      'excel': 'click'
      'editEvent': 'click'
    categoryName: 'EventFilters'
    
```

Enjoy !
All documentation of modules in: http://bitbucket.org/lemontech/limonette/dist/docs

