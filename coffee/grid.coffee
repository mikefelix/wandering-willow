class Grid
  constructor: (opts) ->
    @canvas = opts['canvas']
    @cellSize = opts['cellSize']
    @getDirections = opts['getDirections']
    @getBranchPoint = opts['getBranchPoint']
    @strokeStyle = opts['strokeStyle']
    @currDirection = Math.floor(Math.random() * 8)
    @width = Math.floor(@canvas.width / @cellSize)
    @height = Math.floor(@canvas.height / @cellSize)
    @init()

  init: =>
    @c = @canvas.getContext('2d')
    @c.lineWidth = 1
    @c.strokeStyle = @strokeStyle
    @drawn = new Set()
    @surrounded = new Set()
    @points = {}
    @count = 0
    @center = @point(Math.floor(@width / 2), Math.floor(@height / 2))
    @origin = @center
    @markDrawn @origin

  point: (x,y) => @points[x + '/' + y] or= new Point(x, y, this)
  hasDrawn: (point) => point? and @drawn.contains point
  hasSurrounded: (point) => point? and @surrounded.contains point
  done: => @count >= @width * @height

  markSurrounded: (point) =>
    @drawn.remove point
    @surrounded.add point

  markDrawn: (point) =>
    if not @hasDrawn(point) and not @hasSurrounded(point)
      @drawn.add point
      @count += 1

  findOpenNeighbor: (point) =>
    point = @point(point[0], point[1]) if point instanceof Array
    return null if @hasSurrounded point
    openNeighbors = point.openNeighbors()
    for i in @getDirections point
      neighbor = point.neighborAt i
      if neighbor? and point.neighborIsOpen neighbor
        @currDirection = i
        return neighbor
    null

  drawLine: (origin, dest) =>
    alert("Null point") if !origin? or !dest?
    origin = @point(origin[0], origin[1]) if origin instanceof Array
    dest = @point(dest[0], dest[1]) if dest instanceof Array
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
    @checkSurrounded dest
    dest.neighbors().each (n) => @checkSurrounded n

  checkSurrounded: (point) =>
    @markSurrounded(point) if @hasDrawn(point) and not @hasSurrounded(point) and point.openNeighbors().length() is 0

  draw: =>
    @init()
    @drawOne()

  drawOne: =>
    return if @done()
    dest = null
    while not @origin?.branchable()
      @origin = @getBranchPoint(this)
      if not @origin?
        alert "Can't find branch point."
        return
      dest = @findOpenNeighbor @origin
      @origin = null if not dest?
    dest = @findOpenNeighbor @origin while not dest?
    @drawLine @origin, dest
    @origin = dest
    setTimeout @drawOne, 0

