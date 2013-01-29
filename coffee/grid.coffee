class Grid
  constructor: (opts) ->
    @canvas = opts['canvas']
    @cellSize = opts['cellSize']
    @getDirection = opts['getDirection']
    @drawn = new Set()
    @surrounded = new Set()
    @points = {}
    @count = 0
    @width = Math.floor(@canvas.width / @cellSize)
    @height = Math.floor(@canvas.height / @cellSize)
    @center = @point(Math.floor(@width / 2), Math.floor(@height / 2))
    @init()
    @triggered = false

  point: (x,y) => @points[x + '/' + y] or= new Point(x, y, this)
  hasDrawn: (point) => point? and @drawn.contains point
  hasSurrounded: (point) => point? and @surrounded.contains point
  findBranchPoint: => @drawn.randomElement()
  done: => @count >= (@width + 1) * (@height + 1)

  debug: (where, msg) =>
    elem = $(where)
    return if not elem?
    v = if where == 'news' then elem.value else ''
    elem.value += v + msg

  markSurrounded: (point) =>
    @drawn.remove point
    @surrounded.add point

  markDrawn: (point) =>
    if not @hasDrawn(point) and not @hasSurrounded(point)
      @drawn.add point
      @count += 1

  findOpenNeighbor: (point) =>
    point = @point(point[0], point[1]) if point instanceof Array
    return null if @hasSurrounded(point)
    openNeighbors = point.openNeighbors()
    start = @getDirection point, this
    for i in [0..7]
      neighbor = point.neighborAt (start + i) % 8
      return neighbor if point.neighborIsOpen(neighbor)
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
    @checkSurrounded dest
    dest.neighbors().each (n) => @checkSurrounded n

  checkSurrounded: (point) =>
    a = 1 if @triggered
    @markSurrounded(point) if @hasDrawn(point) and not @hasSurrounded(point) and point.openNeighbors().length() is 0

  init: =>
    @c = @canvas.getContext('2d')
    @c.lineWidth = 1
    @c.strokeStyle = 'black'
    @origin = @center
    @markDrawn @origin

  draw: =>
    @init()
    @drawOne()

  drawOne: =>
    if @done()
      alert "Finished!"
      return
    dest = null
    while not @origin?.branchable()
      @origin = @findBranchPoint()
      if not @origin?
        alert "Can't find branch point."
        return
      dest = @findOpenNeighbor @origin, @getDirection
      @origin = null if not dest?
    dest = @findOpenNeighbor @origin, @getDirection while not dest?
    @drawLine @origin, dest
    @origin = dest
    setTimeout @drawOne, 0

