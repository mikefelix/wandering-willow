class Set
  constructor: (elems...) ->
    @elements = {}
    @added = {}
    @order = []
    initial = if elems.length is 1 and typeof elems[0]?.length is 'number' then elems[0] else elems
    @add i for i in initial
  contains: (e) -> @elements.hasOwnProperty e
  add: (e) ->
    @elements[e] = e
    i = @order.length
    @order[i] = e
    @added[e] = i
  remove: (e) ->
    delete @elements[e]
    @order.splice @added[e], 1
    delete @added[e]
  first: -> @order[0]
  last: -> @order[@order.length - 1]
  findFirst: (f) ->
    for i in [0..@order.length - 1]
      return @order[i] if f @order[i]
    null
  findLast: (f) ->
    for i in [(@order.length - 1)..0]
      return @order[i] if f @order[i]
    null
  length: -> Object.keys(@elements).length
  each: (f) -> f(@elements[item]) for own item of @elements
  toArray: ->
    a = []
    @each (e) -> a.push e
    a
  any: (f) ->
    for own item of @elements
      return true if f @elements[item]
    false
  all: (f) ->
    for own item of @elements
      return false if not f @elements[item]
    true
  filter: (f) ->
    r = new Set()
    for own item of @elements
      e = @elements[item]
      r.add(e) if f(e)
    r
  map: (f) ->
    r = new Set()
    for own item of @elements
      r.add f(@elements[item])
    r
  randomElement: ->
    idx = Math.floor(Math.random() * Object.keys(@elements).length)
    @order[idx]
  toString: ->
    s = 'Set('
    for i in @order
      s += if s == 'Set(' then '' else ', '
      s += @order[i]
    s + ')'

