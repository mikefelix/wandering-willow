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
    @init()

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

  drawLine: (origin, dest) =>
#    alert "Drawing from " + origin + " to " + dest
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
    @origin = @findBranchPoint() until @origin?.branchable()
    dest = @origin.findOpenNeighbor @getDirection
    if !dest?
      alert "No dest found!"
      return
    @drawLine @origin, dest
    @origin = dest
    setTimeout @drawOne, 0

