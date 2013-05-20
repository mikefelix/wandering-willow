describe "Point", ->
  beforeEach ->
    context =
      lineWidth: 10
      strokeStyle: ''
      beginPath: ->
      moveTo: (x,y) ->
      lineTo: (x,y) ->
      closePath: ->
      stroke: ->
      clearRect: ->
    canvas =
      width: 100
      height: 100
      getContext: -> context
    g = new Grid canvas
    g.init
      directionStyle: 'random'
      branchStyle: 'random'
      cellSize: 10
    @p33 = g.point(3, 3)
    @p34 = g.point(3, 4)
    @p35 = g.point(3, 5)
    @p43 = g.point(4, 3)
    @p44 = g.point(4, 4)
    @p45 = g.point(4, 5)
    @p53 = g.point(5, 3)
    @p54 = g.point(5, 4)
    @p55 = g.point(5, 5)

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
