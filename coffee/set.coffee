class Set
  elements: {}
  contains: (e) => @elements.hasOwnProperty(e)
  add: (e) => @elements[e] = e
  remove: (e) => delete @elements[elem]
  first: => return @elements[e] for e of @elements
  any: (f) =>
    for own item of @elements
      return true if f item
    false
  all: (f) =>
    for own item of @elements
      return false if not f item
    true
  findRandomElement: =>
    keys = Object.keys(@elements);
    idx = Math.floor(Math.random() * keys.length)
    for own item of @elements
      return item if i is idx
      i += 1

