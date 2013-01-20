describe "Point", ->
  beforeEach ->
    g = new Grid
      canvas: { width: 500, height: 500 }
      cellSize: 10
      getDirection: DirectionFunctions.random(0.6)
    @p33 = new Point(3, 3, g)
    @p34 = new Point(3, 4, g)
    @p35 = new Point(3, 5, g)
    @p43 = new Point(4, 3, g)
    @p44 = new Point(4, 4, g)
    @p45 = new Point(4, 5, g)
    @p53 = new Point(5, 3, g)
    @p54 = new Point(5, 4, g)
    @p55 = new Point(5, 5, g)

  it 'toStrings', ->
    expect(@p33.toString()).toEqual '3/3'

  it 'finds neighbors by direction', ->
    p = @p44.neighborAt 0
    expect(p.x).toEqual 4
    expect(p.y).toEqual 3
    p = @p44.neighborAt 1
    expect(p.x).toEqual 5
    expect(p.y).toEqual 3
    p = @p44.neighborAt 2
    expect(p.x).toEqual 5
    expect(p.y).toEqual 4
    p = @p44.neighborAt 3
    expect(p.x).toEqual 5
    expect(p.y).toEqual 5
    p = @p44.neighborAt 4
    expect(p.x).toEqual 4
    expect(p.y).toEqual 5
    p = @p44.neighborAt 5
    expect(p.x).toEqual 3
    expect(p.y).toEqual 5
    p = @p44.neighborAt 6
    expect(p.x).toEqual 3
    expect(p.y).toEqual 4
    p = @p44.neighborAt 7
    expect(p.x).toEqual 3
    expect(p.y).toEqual 3
    expect(@p44.neighbors().length()).toEqual 8

  it 'finds directions to neighbors', ->
    expect(@p44.directionTo(@p43)).toEqual 0
    expect(@p44.directionTo(@p53)).toEqual 1
    expect(@p44.directionTo(@p54)).toEqual 2
    expect(@p44.directionTo(@p55)).toEqual 3
    expect(@p44.directionTo(@p45)).toEqual 4
    expect(@p44.directionTo(@p35)).toEqual 5
    expect(@p44.directionTo(@p34)).toEqual 6
    expect(@p44.directionTo(@p33)).toEqual 7
