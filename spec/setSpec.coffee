describe "Set", ->
  beforeEach ->
    @s = new Set()

  it 'should add elements', ->
    @s.add(1)
    expect(@s.contains(1)).toEqual true
