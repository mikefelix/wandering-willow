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

class Set
  elements: {}
  contains: (e) => @elements.hasOwnProperty(e)
  add: (e) => @elements[e] = e
  remove: (e) => delete @elements[elem]
  first: => return @elements[e] for e of @elements
  any: (f) =>
    for own item of @elements
      return true if f item
    false
  all: (f) =>
    for own item of @elements
      return false if not f item
    true
  findRandomElement: =>
    keys = Object.keys(@elements);
    idx = Math.floor(Math.random() * keys.length)
    for own item of @elements
      return item if i is idx
      i += 1

class Point
  constructor: (x, y, @grid) =>
    @x = parseInt x
    @y = parseInt y
    @realX = @x * @grid.cellSize + 1
    @realY = @y * @grid.cellSize + 1
    @connections = new Set()

  toString: => @x + '/' + @y
  drawn: => @grid.hasDrawn this
  surrounded: => @grid.hasSurrounded this
  branchable: => not @surrounded()
  neighbors: => neighborAt(dir) for dir in [0..7]
  openNeighbors: => neighborAt(dir) for dir in [0..7] when not neighborAt(dir).drawn()

  getDirectionTo: (dest) =>
    return 0 if @x is dest.x and @y > dest.y
    return 1 if @x < dest.x and @y > dest.y
    return 2 if @x < dest.x and @y is dest.y
    return 3 if @x < dest.x and @y < dest.y
    return 4 if @x is dest.x and @y < dest.y
    return 5 if @x > dest.x and @y < dest.y
    return 6 if @x > dest.x and @y is dest.y
    return 7 if @x > dest.x and @y > dest.y
    throw "Can't find direction to " + dest.toString()

  neighborAt: (dir) =>
    switch dir
      when 0 then return @neighbors[0] or= new Point(x, y - 1, @grid) if y > 0
      when 1 then return @neighbors[1] or= new Point(x + 1, y - 1, @grid) if x < grid.width and y > 0
      when 2 then return @neighbors[2] or= new Point(x + 1, y, @grid) if x < grid.width
      when 3 then return @neighbors[3] or= new Point(x + 1, y + 1, @grid) if x < grid.width and y < grid.height
      when 4 then return @neighbors[4] or= new Point(x, y + 1, @grid) if y < grid.height
      when 5 then return @neighbors[5] or= new Point(x - 1, y + 1, @grid) if x > 0 and y < grid.height
      when 6 then return @neighbors[6] or= new Point(x - 1, y, @grid) if x > 0
      when 7 then return @neighbors[7] or= new Point(x - 1, y - 1, @grid) if x > 0 and y > 0
    null

  wouldIntersect: (dest, dir) =>
    return false if dir % 2 != 1
    intersector1 = @neighborAt((dir + 1) % 8)
    intersector2 = @neighborAt((dir - 1) % 8)
    intersector1.connections.contains(intersector2) or intersector2.connections.contains(intersector1)

  findOpenNeighbor: (getStartDirection) =>
    return null if @surrounded()
    start = getStartDirection this
    for i in [0..7]
      dir = (start + i) % 8
      point = @neighborAt dir
      return point if point? and not @wouldIntersect(point, dir)

class Grid
  constructor: (@canvas, @cellSize, @getDirection = DirectionFunctions.random()) =>
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

new Grid().hasSurrounded(new Point)

