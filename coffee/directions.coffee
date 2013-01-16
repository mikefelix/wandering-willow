DirectionFunctions =
  random: ->
    (point, grid) -> Math.floor(Math.random() * 8)
  favorDirection: (dir, weight) ->
    (point, grid) -> if Math.random() < weight then dir else Math.floor(Math.random() * 8)
  trendToCenter: (weight) ->
    (point, grid) -> if Math.random() < weight then point.getDirectionTo(grid.center) else Math.floor(Math.random() * 8)
  star: (weight) ->
    (point, grid) -> Math.random() * 8
  bounce: (startDir, weight) ->
    (point, grid) -> Math.random() * 8
