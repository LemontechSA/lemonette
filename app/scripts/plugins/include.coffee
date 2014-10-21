Function::include = (mixin) ->
  @::[key] = value for key, value of mixin::
  @
