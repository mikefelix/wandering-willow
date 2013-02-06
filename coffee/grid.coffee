class Grid
  constructor: (opts) ->
    @onDone = opts['onDone']
    @canvas = opts['canvas']
    @c = @canvas.getContext('2d')
    @c.lineWidth = 1
    @c.strokeStyle = opts['strokeStyle']
    @cellSize = opts['cellSize']
    @directionFunctions = new DirectionFunctions()
    @branchFunctions = new BranchFunctions()
    @currDirection = Math.floor(Math.random() * 8)
    @width = Math.floor(@canvas.width / @cellSize)
    @height = Math.floor(@canvas.height / @cellSize)

  init: (opts) =>
    clearTimeout(window.drawTimer) if window? and window.drawTimer?
    @c.clearRect 0, 0, @canvas.width, @canvas.height
    @getDirections = @directionFunctions[opts['directionStyle']](opts['directionArg'])
    @getDirections = @directionFunctions.weight(opts['weight'], @getDirections) if opts['weight']?
    @getBranchPoint = @branchFunctions[opts['branchStyle']]()
    @maxBranchAge = opts['branchTtl']
    @fillPercent = opts['fillPercent']
    @drawn = new Set()
    @surrounded = new Set()
    @points = {}
    @count = 0
    @branchAge = 0
    @center = @point(Math.floor(@width / 2), Math.floor(@height / 2))
    @origin = @center
    @markDrawn @origin

  point: (x,y) => @points[x + '/' + y] or= new Point(x, y, this)

  hasDrawn: (point) => point? and @drawn.contains point

  hasSurrounded: (point) => point? and @surrounded.contains point

  done: => @count >= @width * @height * @fillPercent

  checkSurrounded: (point) =>
    @markSurrounded(point) if @hasDrawn(point) and not @hasSurrounded(point) and point.openNeighbors().length() is 0

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
    if @drawn.length() != Object.keys(@drawn.elements).length or @drawn.length() != @drawn.order.length
      alert @drawn.length() + ' / ' + Object.keys(@drawn.elements).length + ' / ' + @drawn.order.length

  drawLoop: =>
    @drawOne()
    window.drawTimeout = setTimeout @drawLoop, 0

  drawOne: =>
    if @done()
      @onDone() if @onDone?
      return
    dest = null
    while not @origin?.branchable() or (@maxBranchAge? and @branchAge >= @maxBranchAge)
      @branchAge = 0
      bCount = if bCount? then bCount + 1 else 1
      if bCount > 1000
        alert 'Infinite loop while finding branch.' # + tried[0].toString() + ',' + tried[1].toString() + ',' + tried[2].toString()
        return
      @origin = @getBranchPoint(this)
      if not @origin?
        alert "Can't find branch point."
        return
      dest = @findOpenNeighbor @origin
      @origin = null if not dest?
    dest = @findOpenNeighbor @origin while not dest?
    @drawLine @origin, dest
    @origin = dest
    @branchAge++

  draw: (opts) =>
    @init(opts)
    @drawLoop()

