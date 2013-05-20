describe 'control', ->
  elem = null
  scope = null

  beforeEach module 'WillowApp'

  it 'should generate slider control html', ->
    inject ($rootScope, $compile, control) ->
      elem = angular.element '''
                             <div control="numberTest" />
                             '''
      scope = $rootScope.$new()
      scope.numberTest = control
          id: 'test'
          name: 'Test number'
          min: 0
          max: 7
          step: 1
          start: 3
          display: 'formatted'
          convert: 'logarithmic'

      $compile(elem)(scope)
      scope.$digest()

      expect(elem.attr 'id').toBe 'testControl'
      expect(elem.find('.slider div:first').attr('id')).toBe 'testSlide'
      expect(elem.find('input').attr('id')).toBe 'test'
      expect(elem.find('input').val()).toBe '1000'
      expect(elem.find('#testText').html()).toBe '1,000'

  it 'should generate checkbox control html', ->
    inject ($rootScope, $compile, control) ->
      elem = angular.element '''
                             <div control="boolTest" />
                             '''
      elem2 = angular.element '''
                              <div control="boolTest2" />
                              '''

      scope = $rootScope.$new()
      scope.boolTest = control
        id: 'test'
        name: 'Test boolean true'
        start: true
      scope.boolTest2 = control
        id: 'test2'
        name: 'Test boolean false'
        start: false

      $compile(elem)(scope)
      $compile(elem2)(scope)
      scope.$digest()

      expect(elem.attr 'id').toBe 'testControl'
      expect(elem2.attr 'id').toBe 'test2Control'

      expect(elem.find('#test')[0].checked).toBe true
      expect(elem2.find('#test2')[0].checked).toBe false

#      expect(scope.boolTest2.value).toBe false
#      elem2.trigger('click')
#      scope.$digest()
#      expect(elem2.find('#test2')[0].checked).toBe true
#      expect(scope.boolTest2.value).toBe true


  it 'should generate radio control html', ->
    inject ($rootScope, $compile, control) ->
      elem = angular.element '''
                             <div control="stringTest" />
                             '''

      scope = $rootScope.$new()
      scope.stringTest = control
        id: 'test'
        name: 'Test string'
        start: 'b'
        options: [
          id: 'a',
          name: 'A'
        ,
          id: 'b'
          name: 'B'
        ,
          id: 'c'
          name: 'C'
        ]

      $compile(elem)(scope)
      scope.$digest()

      expect(elem.attr 'id').toBe 'testControl'
      expect(elem.find('input[type=radio]').length).toBe 3
#      expect(elem.find('#testRadio0').checked).toBe false
#      expect(elem.find('#testRadio1').checked).toBe true
#      expect(elem.find('#testRadio2').checked).toBe false
