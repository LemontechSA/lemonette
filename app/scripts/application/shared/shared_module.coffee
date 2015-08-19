#= require auto_fillable.coffee
#= require cacheable_collection.coffee
#= require live_collection.coffee
#= require processes.coffee

###
This module contains the base classes for spiced routers
@see Lemonette.Module
###
class @Lemonette.SharedModule extends Lemonette.Module
  ###
  Class {Lemonette.AutoFillable}
  ###
  AutoFillable: Lemonette.AutoFillable
  ###
  Class {Lemonette.CacheableCollection}
  ###
  CacheableCollection: Lemonette.CacheableCollection
  ###
  Class {Lemonette.LiveCollection}
  ###  
  LiveCollection: Lemonette.LiveCollection
  ###
  Class {Lemonette.Processes}
  ###
  Processes: Lemonette.Processes