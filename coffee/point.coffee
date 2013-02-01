class Point
  constructor: (x, y, @grid) ->
    @x = parseInt x
    @y = parseInt y
    @realX = @x * @grid.cellSize + 1
    @realY = @y * @grid.cellSize + 1
    @connections = new Set()

  toString: => @x + '/' + @y
#  drawn: => @grid.hasDrawn this
#  surrounded: => @grid.hasSurrounded this
  branchable: => not @grid.hasSurrounded(this)
  neighbors: => new Set(@neighborAt(dir) for dir in [0..7])
#  openNeighbors: => new Set(@neighborAt(dir) for dir in [0..7] when not @grid.hasDrawn(@neighborAt(dir)))
  neighborIsOpen: (p) => p? and not @grid.hasDrawn(p) and not @grid.hasSurrounded(p) and not @wouldIntersect(p)
  openNeighbors: =>
    @neighbors().filter (p) => @neighborIsOpen(p)

  directionTo: (dest) =>
    return null if !dest?
    return 0 if @x is dest.x and @y > dest.y
    return 1 if @x < dest.x and @y > dest.y
    return 2 if @x < dest.x and @y is dest.y
    return 3 if @x < dest.x and @y < dest.y
    return 4 if @x is dest.x and @y < dest.y
    return 5 if @x > dest.x and @y < dest.y
    return 6 if @x > dest.x and @y is dest.y
    return 7 if @x > dest.x and @y > dest.y
    throw "Can't find direction from " + @x + "/" + @y + " to " + dest.toString()

  neighborAt: (dir) =>
    return null if !dir?
    switch dir
      when 0 then return @neighbors[0] or= @grid.point(@x, @y - 1) if @y > 0
      when 1 then return @neighbors[1] or= @grid.point(@x + 1, @y - 1) if @x < @grid.width and @y > 0
      when 2 then return @neighbors[2] or= @grid.point(@x + 1, @y) if @x < @grid.width
      when 3 then return @neighbors[3] or= @grid.point(@x + 1, @y + 1) if @x < @grid.width and @y < @grid.height
      when 4 then return @neighbors[4] or= @grid.point(@x, @y + 1) if @y < @grid.height
      when 5 then return @neighbors[5] or= @grid.point(@x - 1, @y + 1) if @x > 0 and @y < @grid.height
      when 6 then return @neighbors[6] or= @grid.point(@x - 1, @y) if @x > 0
      when 7 then return @neighbors[7] or= @grid.point(@x - 1, @y - 1) if @x > 0 and @y > 0
    null

  wouldIntersect: (dest, dir = null) =>
    dir = @directionTo(dest) if not dir?
    return false if dir % 2 != 1
    intersector1 = @neighborAt((dir + 1) % 8)
    intersector2 = @neighborAt((dir - 1) % 8)
    intersector1?.connections.contains(intersector2) or intersector2?.connections.contains(intersector1)



