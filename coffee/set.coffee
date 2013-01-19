class Set
#  elements: {}
  constructor: (elems...) ->
    @elements = {}
    for i in elems
      @elements[i] = i
  contains: (e) -> @elements.hasOwnProperty(e)
  add: (e) -> @elements[e] = e
  remove: (e) -> delete @elements[e]
  first: -> return @elements[e] for e of @elements
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
  length: -> Object.keys(@elements).length
#    i = 0
#    for own o of @elements
#      i++
#    i
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

