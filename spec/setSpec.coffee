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

  it 'should add and not duplicate elements', ->
    @s.add 1
    @s.add 1
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual false
    expect(@s.length()).toEqual 1
    expect(@s.order.length).toEqual 1

  it 'should remove elements', ->
    @s.add 1
    @s.add 2
    @s.add 3
    @s.add 4
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(2)).toEqual true
    expect(@s.contains(3)).toEqual true
    expect(@s.contains(4)).toEqual true
    expect(@s.length()).toEqual 4
    expect(@s.order.length).toEqual 4
    expect(Object.keys(@s.added).length).toEqual 4
    expect(Object.keys(@s.elements).length).toEqual 4
    expect(@s.order[0]).toEqual 1
    expect(@s.order[1]).toEqual 2
    expect(@s.order[2]).toEqual 3
    expect(@s.order[3]).toEqual 4
    expect(@s.elements[4]).toEqual 4
    expect(@s.added[1]).toEqual 0
    expect(@s.added[4]).toEqual 3
    @s.remove 4
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(3)).toEqual true
    expect(@s.contains(2)).toEqual true
    expect(@s.contains(4)).toEqual false
    expect(@s.length()).toEqual 3
    expect(@s.order.length).toEqual 3
    expect(Object.keys(@s.added).length).toEqual 3
    expect(Object.keys(@s.elements).length).toEqual 3
    expect(@s.order[0]).toEqual 1
    expect(@s.order[1]).toEqual 2
    expect(@s.order[2]).toEqual 3
    expect(@s.order[3]).toEqual undefined
    expect(@s.elements[4]).toEqual undefined
    expect(@s.added[4]).toEqual undefined
    expect(@s.added[3]).toEqual 2
    @s.remove 2
    expect(@s.contains(1)).toEqual true
    expect(@s.contains(3)).toEqual true
    expect(@s.contains(2)).toEqual false
    expect(@s.contains(4)).toEqual false
    expect(@s.length()).toEqual 2
    expect(@s.order.length).toEqual 2
    expect(Object.keys(@s.added).length).toEqual 2
    expect(Object.keys(@s.elements).length).toEqual 2
    expect(@s.order[0]).toEqual 1
    expect(@s.order[1]).toEqual 3
    expect(@s.order[2]).toEqual undefined
    expect(@s.elements[2]).toEqual undefined
    expect(@s.elements[3]).toEqual 3
    expect(@s.elements[1]).toEqual 1
    expect(@s.elements[4]).toEqual undefined
    expect(@s.added[3]).toEqual 1

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

  it 'converts to array', ->
    @s.add 1
    @s.add 2
    @s.add 3
    expect(@s.toArray()).toEqual [1,2,3]