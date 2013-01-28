class Set
  constructor: (elems...) ->
    @elements = {}
    e = if elems.length is 1 and typeof elems[0]?.length is 'number' then elems[0] else elems
    @elements[i] = i for i in e
  contains: (e) -> @elements.hasOwnProperty(e)
  add: (e) -> @elements[e] = e
  remove: (e) -> delete @elements[e]
  first: -> return @elements[e] for e of @elements
  length: -> Object.keys(@elements).length
  each: (f) ->
    for own item of @elements
      f(@elements[item])
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
#      alert item + ': ' + f(@elements[item])
      r.add(item) if f @elements[item]
    r
  map: (f) ->
    r = new Set()
    for own item of @elements
      r.add f(@elements[item])
    r
  findRandomElement: ->
    idx = Math.floor(Math.random() * Object.keys(@elements).length)
    i = 0
    for own item of @elements
      return item if i is idx
      i += 1
  toString: ->
    s = 'Set('
    for own i of @elements
      s += if s == 'Set(' then '' else ', '
      s += i
    s + ')'

