class DirectionFunctions
  all: [0,1,2,3,4,5,6,7]
  weight: (w, func) ->
    (point) => if @weightCheck w then func point else @randomize @all
  random: ->
    (point) => @randomize @all
  favorDirection: (dir) ->
    (point) => @randomize dir, [(dir + 1) % 8, (dir + 7) % 8]
  trendToCenter: ->
    (point) => @favorDirection(point.directionTo point.grid.center)(point)
  x: (width) ->
    (point) =>
      if Math.abs(point.x - point.y) <= width or point.grid.width - (point.x + point.y) <= width
        @favorDirection((point.directionTo(point.grid.center) + 4) % 8) point
      else
        @randomize @all
  explode: ->
    (point) => @favorDirection((point.directionTo(point.grid.center) + 4) % 8) point
  jagged: ->
    (point) => @randomize [1,3,5,7]
  squarish: ->
    (point) => @randomize [0,2,4,6]
  inertia: (mutationRate) ->
    (point) =>
      dir = point.grid.currDirection
      if @weightCheck mutationRate
        point.grid.currDirection = if Math.random() < 0.5 then dir - 1 else dir + 1
      @favorDirection(point.grid.currDirection) point
  bounce: (startDir) ->
    (point) =>
      grid = point.grid
      if point.y is 0
        grid.currDirection = 5 if grid.currDirection is 7
        grid.currDirection = 3 if grid.currDirection is 1
        grid.currDirection = 4 if grid.currDirection is 0
      else if point.y >= grid.height - 1
        grid.currDirection = 7 if grid.currDirection is 5
        grid.currDirection = 1 if grid.currDirection is 3
        grid.currDirection = 0 if grid.currDirection is 4
      if point.x is 0
        grid.currDirection = 3 if grid.currDirection is 5
        grid.currDirection = 2 if grid.currDirection is 6
        grid.currDirection = 1 if grid.currDirection is 7
      else if point.x >= grid.width - 1
        grid.currDirection = 5 if grid.currDirection is 3
        grid.currDirection = 6 if grid.currDirection is 2
        grid.currDirection = 7 if grid.currDirection is 1
      @favorDirection(grid.currDirection) point
  # private
  weightCheck: (weight) -> Math.random() < weight
  randomize: (groups...) ->
    shuffle = (list) ->
      n = list.length
      while n > 1
        k = Math.floor(Math.random() * n--)
        temp = list[n]
        list[n] = list[k]
        list[k] = temp
      list
    all = new Set(0,1,2,3,4,5,6,7)
    res = []
    for g in groups
      if g instanceof Array
        shuffle g
        for elem in g
          res.push elem
          all.remove elem
      else
        res.push g
        all.remove g
    a = all.toArray()
    shuffle a
    res.push e for e in a
    res

class BranchFunctions
  random: ->
    (grid) => grid.drawn.randomElement()
  fromStart: ->
    (grid) => grid.drawn.findFirst (p) -> p.openNeighbors().length() > 0
  fromEnd: ->
    (grid) => grid.drawn.findLast (p) -> p.openNeighbors().length() > 0