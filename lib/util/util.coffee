
@Util =
  trim: (val) ->
    if val? then val.replace /^\s*|\s*$/g, "" else val
