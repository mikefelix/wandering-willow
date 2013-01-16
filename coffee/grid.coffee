class Grid
  constructor: (@canvas, @cellSize, @getDirection = DirectionFunctions.random()) ->
    @windowHeight = window.innerHeight
    @windowWidth = window.innerWidth
    @canvas.width = @canvas.style.width = windowWidth
    @canvas.height = @canvas.style.height = windowHeight
    @pixelWidth = parseInt(@canvas.style.width.replace(/\D/, ''))
    @pixelHeight = parseInt(@canvas.style.height.replace(/\D/, ''))
    @center = new Point(Math.floor(this.width / 2), Math.floor(this.height / 2), this)
    @width = Math.floor(@pixelWidth / @cellSize)
    @height = Math.floor(@pixelHeight / @cellSize)
    @count = 0
    @drawn = new Set()
    @surrounded = new Set()

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

