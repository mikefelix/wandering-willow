describe "Grid", ->
  beforeEach ->
    context = {
      lineWidth: 10
      strokeStyle: ''
      beginPath: ->
      moveTo: (x,y) ->
      lineTo: (x,y) ->
      closePath: ->
      stroke: ->
    }
    canvas = {
      width: 100
      height: 100
      getContext: context
    }
    @g = new Grid {
      canvas: canvas
      cellSize: 10
      getDirection: DirectionFunctions.random()
    }

    it 'keeps track of drawn cells', ->
      @g.drawLine new Point(4,4), new Point(4,5)
      expect(@g.hasDrawn(4,4)).toEqual true
      expect(@g.hasSurrounded(4,4)).toEqual false
      expect(@g.hasDrawn(4,5)).toEqual true
      expect(@g.hasSurrounded(4,5)).toEqual false
      expect(@g.hasDrawn(5,5)).toEqual false
      expect(@g.count).toEqual 1



