drawAndCheck = (grid, from, to, expectDrawn, expectSurrounded, block = null) ->
  grid.drawLine from, to
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

  it 'always finds the only open neighbor', ->
    @g.drawn.add(@g.point(5,5))
    @g.drawn.add(@g.point(5,4))
    @g.drawn.add(@g.point(6,6))
    @g.drawn.add(@g.point(6,5))
    @g.drawn.add(@g.point(6,4))
    @g.drawn.add(@g.point(4,6))
    @g.drawn.add(@g.point(4,5))
    @g.drawn.add(@g.point(4,4))
    o = @g.findOpenNeighbor([5,5])
    expect(o.toString()).toEqual '5/6'
    for i in [0..7]
      expect(@g.findOpenNeighbor([5,5]).toString()).toEqual o.toString()

  it 'always finds the only open neighbor on edges', ->
    @g.drawn.add(@g.point(1,1))
    @g.drawn.add(@g.point(1,0))
    @g.drawn.add(@g.point(0,1))
    @g.drawn.add(@g.point(2,0))
    @g.drawn.add(@g.point(2,1))
    @g.drawn.add(@g.point(2,2))
    @g.drawn.add(@g.point(1,2))
    @g.drawn.add(@g.point(0,2))
    o = @g.findOpenNeighbor([1,1])
    expect(o.toString()).toEqual '0/0'
    for i in [0..7]
      expect(@g.findOpenNeighbor([1,1]).toString()).toEqual o.toString()

  it 'detects intersection', ->
    expect(@g.origin.toString()).toEqual @g.point(5, 5).toString()
    drawAndCheck @g, [5,5], [6,6], 2, 0
    drawAndCheck @g, [6,6], [6,5], 3, 0
    expect(@g.point(6,5).wouldIntersect(@g.point(5,6))).toEqual true
    expect(@g.point(6,5).wouldIntersect(@g.point(7,5))).toEqual false

  it 'keeps track of drawn cells', ->
    expect(@g.origin.toString()).toEqual @g.point(5, 5).toString()
    drawAndCheck @g, [5,5], [5,6], 2, 0
    drawAndCheck @g, [5,6], [6,6], 3, 0
    drawAndCheck @g, [6,6], [6,5], 4, 0
    drawAndCheck @g, [6,5], [6,4], 5, 0
    drawAndCheck @g, [6,4], [5,4], 6, 0
    drawAndCheck @g, [5,4], [4,4], 7, 0
    drawAndCheck @g, [4,4], [4,5], 8, 0
    drawAndCheck @g, [4,5], [4,6], 8, 1, => @g.surrounded.contains @g.point(5, 5)

  it 'can surround cells', ->
    @g.drawn.add @g.point(5,5)
    @g.drawn.add @g.point(5,6)
    @g.drawn.add @g.point(6,6)
    @g.drawn.add @g.point(6,5)
    @g.drawn.add @g.point(6,4)
    @g.drawn.add @g.point(5,4)
    @g.drawn.add @g.point(4,4)
    @g.drawn.add @g.point(4,5)
    @g.checkSurrounded @g.point(5,5)
    expect(@g.hasSurrounded(@g.point(5,5))).toEqual false
    @g.drawn.add @g.point(4,6)
    expect(@g.point(5,5,@g).neighbors().all((p) => @g.hasDrawn p)).toEqual true
    @g.triggered = true
    @g.checkSurrounded @g.point(5,5)
    expect(@g.hasSurrounded(@g.point(5,5))).toEqual true

  it "doesn't overlap lines", ->
    p = [5,5]
    p = drawAndCheck @g, p, [4,6], 2, 0
    p = drawAndCheck @g, p, [5,7], 3, 0
    p = drawAndCheck @g, p, [6,6], 4, 0
    p = drawAndCheck @g, p, [6,5], 5, 0
    p = drawAndCheck @g, p, [5,6], 5, 1, => @g.surrounded.contains @g.point(5, 6) # is now surrounded because of wouldIntersect


