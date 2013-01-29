describe "Set", ->
  beforeEach ->
    @s = new Set()

  it 'construct', ->
    expect(new Set(1,2,3,4).length()).toEqual 4
    expect(new Set([1,2,3]).length()).toEqual 3
    a = new Set()
    a.add '1'
    b = new Set()
    expect(b.contains('1')).toEqual false

  it 'should construct well', ->
    @s = new Set('1', '2', '3')
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual true
    expect(@s.contains(3)).toEqual true
    expect(@s.contains(4)).toEqual false
    expect(@s.length()).toEqual 3

  it 'should add elements', ->
    @s.add 1
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual false
    expect(@s.length()).toEqual 1

  it 'should not duplicate elements', ->
    @s.add 1
    @s.add 1
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual false
    expect(@s.length()).toEqual 1

  it 'should remove elements', ->
    @s.add 1
    @s.add 2
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual true
    expect(@s.length()).toEqual 2
    @s.remove 2
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual false
    expect(@s.length()).toEqual 1

  it 'should return what was added', ->
    @s.add '1'
    expect(@s.first()).toEqual '1'

  it 'should return a random element', ->
    @s.add '1'
    @s.add '2'
    @s.add '3'
    rand = @s.randomElement()
    expect(new Set('1', '2', '3').contains(rand)).toEqual true

  it 'should find elements fitting criteria', ->
    @s.add '1'
    @s.add '2'
    @s.add '3'
    expect(@s.all((i) -> parseInt(i) < 4)).toEqual true
    expect(@s.any((i) -> parseInt(i) < 4)).toEqual true
    expect(@s.all((i) -> parseInt(i) < 3)).toEqual false
    expect(@s.any((i) -> parseInt(i) < 3)).toEqual true
    expect(@s.any((i) -> parseInt(i) > 3)).toEqual false
    expect(@s.filter((a) -> parseInt(a) < 3).contains(2)).toEqual true
    p = @s.filter((a) -> parseInt(a) < 2)
    expect(p.contains(2)).toEqual false

  it 'should map correctly', ->
    @s.add 1
    @s.add 300
    @s.add 20
    s2 = @s.map((a) -> a * 2)
    expect(s2.length()).toEqual 3
    expect(s2.contains(2)).toEqual true
    expect(s2.contains(600)).toEqual true
    expect(s2.contains(40)).toEqual true
    expect(s2.contains(41)).toEqual false
