drawAndCheck = (grid, from, to, expectDrawn, expectSurrounded, block = null) ->
  grid.drawLine new Point(from[0], from[1], grid), new Point(to[0], to[1], grid)
  expect(grid.drawn.length()).toEqual expectDrawn
  expect(grid.surrounded.length()).toEqual expectSurrounded
  expect(block()).toEqual(true) if block?
  to

describe "Grid", ->
  beforeEach ->
    context =
      lineWidth: 10
      strokeStyle: ''
      beginPath: ->
      moveTo: (x,y) ->
      lineTo: (x,y) ->
      closePath: ->
      stroke: ->
    canvas =
      width: 100
      height: 100
      getContext: -> context
    @g = new Grid
      canvas: canvas
      cellSize: 10
      getDirection: DirectionFunctions.random()

  it 'can surround cells', ->
    @g.drawn.add new Point(5,5,@g)
    @g.drawn.add new Point(5,6,@g)
    @g.drawn.add new Point(6,6,@g)
    @g.drawn.add new Point(6,5,@g)
    @g.drawn.add new Point(6,4,@g)
    @g.drawn.add new Point(5,4,@g)
    @g.drawn.add new Point(4,4,@g)
    @g.drawn.add new Point(4,5,@g)
    @g.checkSurrounded new Point(5,5,@g)
    expect(@g.hasSurrounded(new Point(5,5,@g))).toEqual false
    @g.drawn.add new Point(4,6,@g)
    expect(new Point(5,5,@g).neighbors().all((p) => @g.hasDrawn p)).toEqual true
    @g.checkSurrounded new Point(5,5,@g)
    expect(@g.hasSurrounded(new Point(5,5,@g))).toEqual true

  it 'detects intersection', ->
    expect(@g.origin.toString()).toEqual new Point(5, 5, @g).toString()
    drawAndCheck @g, [5,5], [6,6], 2, 0
    drawAndCheck @g, [6,6], [6,5], 3, 0
    expect(new Point(6,5,@g).wouldIntersect(new Point(5,6,@g))).toEqual true
    expect(new Point(6,5,@g).wouldIntersect(new Point(7,5,@g))).toEqual false

  it 'keeps track of drawn cells', ->
    expect(@g.origin.toString()).toEqual new Point(5, 5, @g).toString()
    drawAndCheck @g, [5,5], [5,6], 2, 0
    drawAndCheck @g, [5,6], [6,6], 3, 0
    drawAndCheck @g, [6,6], [6,5], 4, 0
    drawAndCheck @g, [6,5], [6,4], 5, 0
    drawAndCheck @g, [6,4], [5,4], 6, 0
    drawAndCheck @g, [5,4], [4,4], 7, 0
    drawAndCheck @g, [4,4], [4,5], 8, 0
    drawAndCheck @g, [4,5], [4,6], 8, 1, => @g.surrounded.contains new Point(5, 5, @g)

  it "doesn't overlap lines", ->
    p = [5,5]
    p = drawAndCheck @g, p, [4,6], 2, 0
    p = drawAndCheck @g, p, [5,7], 3, 0
    p = drawAndCheck @g, p, [6,6], 4, 0
    p = drawAndCheck @g, p, [6,5], 5, 0
    p = drawAndCheck @g, p, [5,6], 5, 1, => @g.surrounded.contains new Point(5, 6, @g) # is now surrounded because of wouldIntersect


