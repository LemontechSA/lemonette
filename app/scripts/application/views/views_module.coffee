#= require trackable.coffee
#= require layout.coffee
#= require item_view.coffee
#= require collection_view.coffee
#= require composite_view.coffee

###
This module contains the base classes for spiced routers
@see Lemonette.Module
###
class @Lemonette.ViewsModule extends Lemonette.Module
  ###
  Class {Lemonette.Trackable}
  ###
  Trackable: Lemonette.Trackable
  ###
  Class {Lemonette.Layout}
  ###
  Layout: Lemonette.Layout
  ###
  Class {Lemonette.ItemView}
  ###
  ItemView: Lemonette.ItemView
  ###
  Class {Lemonette.CollectionView}
  ###
  CollectionView: Lemonette.CollectionView
  ###
  Class {Lemonette.CompositeView}
  ###
  CompositeView: Lemonette.CompositeView
  ###
  Class {Lemonette.BackboneView}
  ###
  BackboneView: Lemonette.BackboneView