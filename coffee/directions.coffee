DirectionFunctions =
  random: ->
    (point, grid) => @getRandomDir()
  favorDirection: (dir, weight) ->
    (point, grid) => if @weightCheck(weight) then dir else @getRandomDir()
  trendToCenter: (weight) ->
    (point, grid) => if @weightCheck(weight) then point.directionTo(grid.center) else @getRandomDir()
  x: (width, weight) ->
    (point, grid) =>
      return @getRandomDir() if point is grid.center
      if @weightCheck(weight) and (Math.abs(point.x - point.y) <= width or grid.width - (point.x + point.y) <= width)
        (point.directionTo(grid.center) + 4) % 8
      else
        @getRandomDir()
  explode: ->
    (point, grid) =>
      return @getRandomDir() if point is grid.center
      toCenter = point.directionTo(grid.center)
      while not d? or d is toCenter
        d = @getRandomDir()
      d
  jagged: ->
    (point, grid) =>
      while not d? or d % 2 is 0
        d = @getRandomDir()
      d
  squarish: ->
    (point, grid) =>
      while not d? or d % 2 is 1
        d = @getRandomDir()
      d
  bounce: (startDir, weight) ->
    (point, grid) => @getRandomDir()
  # private
  getRandomDir: -> Math.floor(Math.random() * 8)
  weightCheck: (weight) -> Math.random() < weight

BranchFunctions =
  random: =>
    (grid) => grid.drawn.randomElement()
  fromStart: =>
    (grid) => grid.drawn.first()