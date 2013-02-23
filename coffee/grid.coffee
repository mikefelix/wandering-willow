class Grid
  constructor: (@canvas, @onDone) ->
    @directionFunctions = new DirectionFunctions()
    @branchFunctions = new BranchFunctions()

  init: (opts) =>
    clearTimeout(window.drawTimer) if window? and window.drawTimer?
    @c = @canvas.getContext('2d')
    @c.lineWidth = 1
    @c.clearRect 0, 0, @canvas.width, @canvas.height
    @strokeStyle = opts['strokeStyle']
    @cellSize = opts['cellSize'] or 10
    @currDirection = Math.floor(Math.random() * 8)
    @width = Math.floor(@canvas.width / @cellSize)
    @height = Math.floor(@canvas.height / @cellSize)
    @getDirections = @directionFunctions[opts['directionStyle']](opts['directionArg'])
    @getDirections = @directionFunctions.weight(opts['weight'], @getDirections) if opts['weight']?
    @getBranchPoint = @branchFunctions[opts['branchStyle']]()
    @maxBranchAge = parseInt opts['branchTtl']
    @fillPercent = parseFloat opts['fillPercent'] if opts['fillPercent']?
    @maxBranchCount = parseInt opts['maxBranchCount'] if opts['maxBranchCount']?
    @onDone = opts['onDone'] if opts['onDone']?
    @drawn = new Set()
    @surrounded = new Set()
    @points = {}
    @branchCount = 0
    @count = 0
    @branchAge = 0
    @center = @point(Math.floor(@width / 2), Math.floor(@height / 2))
    @origin = @center
    @markDrawn @origin
    @finish = false

  getStrokeStyle: ->
    return @strokeStyle() if typeof @strokeStyle is 'function'
    if @strokeStyle is 'fade'
      step = 256 / @maxBranchAge
      num = 255 - parseInt(@branchAge * step)
      hex = num.toString(16)
      hex = '0' + hex if hex.length is 1
      '#' + hex + hex + hex
    else
      @strokeStyle

  point: (x,y) => @points[x + '/' + y] or= new Point(x, y, this)

  hasDrawn: (point) => point? and @drawn.contains point

  hasSurrounded: (point) => point? and @surrounded.contains point

  done: =>
    d = if @finish
      true
    else if @maxBranchCount?
      @branchCount >= @maxBranchCount
    else if @fillPercent?
      @count >= @width * @height * @fillPercent
    else
      @count >= @width * @height
    @onDone() if d and @onDone?
    d

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
    @c.strokeStyle = @getStrokeStyle()
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
    if @drawOne()
      window.drawTimeout = setTimeout @drawLoop, 0

  drawOne: =>
    return true if @done()
    dest = null
    while not @origin?.branchable() or (@maxBranchAge? and @branchAge >= @maxBranchAge)
      @branchAge = 0
      @branchCount++
      return true if @done()
      bCount = if bCount? then bCount + 1 else 1
      if bCount > 1000
        alert 'Infinite loop while finding branch.' # + tried[0].toString() + ',' + tried[1].toString() + ',' + tried[2].toString()
        return false
      @origin = @getBranchPoint(this)
      if not @origin?
        alert "Can't find branch point."
        return false
      dest = @findOpenNeighbor @origin
      @origin = null if not dest?
    dest = @findOpenNeighbor @origin while not dest?
    @drawLine @origin, dest
    @origin = dest
    @branchAge++
    true

  draw: (opts) =>
    @init(opts)
    @drawLoop()

