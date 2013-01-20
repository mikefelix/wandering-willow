class Grid
  constructor: (opts) ->
    @canvas = opts['canvas']
    @cellSize = opts['cellSize']
    @getDirection = opts['getDirection']
    @width = Math.floor(@canvas.width / @cellSize)
    @height = Math.floor(@canvas.height / @cellSize)
    @center = new Point(Math.floor(@width / 2), Math.floor(@height / 2), this)
    @drawn = new Set()
    @surrounded = new Set()
    @count = 0

  hasDrawn: (point) => not point? or @drawn.contains point
  hasSurrounded: (point) => @surrounded.contains point
  findBranchPoint: => @drawn.randomElement()
  done: => @count >= (@width + 1) * (@height + 1)

  debug: (where, msg) =>
    elem = $(where)
    return if not elem?
    v = if where == 'news' then elem.value else ''
    elem.value += v + msg

  markSurrounded: (point) =>
    if not @surrounded.contains point
      @drawn.remove point
      @surrounded.add point

  markDrawn: (point) =>
    if not @drawn.contains(point) and not @surrounded.contains(point)
      @drawn.add point
      @count += 1

  drawLine: (origin, dest) =>
    @c.beginPath()
    @c.moveTo origin.realX, origin.realY
    @c.lineTo dest.realX, dest.realY
    @c.closePath()
    @c.stroke()
    @c.stroke()
    @markDrawn origin
    @markDrawn dest
    origin.connections.add dest
#    @checkSurrounded origin
#    for n in origin.neighbors()
#      @checkSurrounded n
    @checkSurrounded dest
    for n in dest.neighbors()
      @checkSurrounded n

  checkSurrounded: (point) =>
    if point?.drawn() and not point.surrounded()
      if point.neighbors().any((p) -> not @hasDrawn p)
        @markSurrounded point

  draw: =>
    @c = @canvas.getContext('2d')
    @c.lineWidth = 1
    @c.strokeStyle = 'black'
    @origin = @center
    @markDrawn @origin
    @drawOne()

  drawOne: =>
    return 'Finished!' if @done()
    @origin = @findBranchPoint() until @origin?.branchable()
    dest = @origin.findOpenNeighbor @getDirection
    return if !dest?
    @drawLine @origin, dest
    @origin = dest
    setTimeout @drawOne, 0

