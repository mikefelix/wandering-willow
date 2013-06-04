app = angular.module 'WillowApp', []

app.value 'directions', ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest']

app.factory 'control', (directions) ->
  (opts) ->
    convertFuncs =
      logarithmic: (value) -> Math.floor(Math.pow(10, value))
      percent: (value) -> value * 100
    displayFuncs =
      directional: (value) -> directions[value]
      percent: (value) -> Math.floor(value * 100) + '%'
      formatted: (value) ->
        sign = if value < 0 then "-" else ""
        i = parseInt(Math.abs(+value || 0).toFixed(2)) + ""
        j = if i.length > 3 then i.length % 3 else 0
        q = if j then i.substr(0, j) + ',' else ''
        sign + q + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + ',')

    id: opts.id
    name: opts.name
    min: opts.min
    max: opts.max
    step: opts.step
    value: if opts.start is undefined then opts.value else opts.start
    options: opts.options
    convert: convertFuncs[opts.convert] or (a) -> a
    display: displayFuncs[opts.display] or (a) -> a
    setValue: (v) ->
      @value = @convert v
      @displayText = @display @value

app.controller 'WillowCtrl', ($scope, control) ->
  $scope.weight = control
    id: 'weight'
    name: 'Randomization'
    min: 0
    max: 1
    step: 0.01
    start: 0.02
    display: 'percent'
  $scope.direction = control
    id: 'direction'
    name: 'Direction'
    min: 0
    max: 7
    step: 1
    start: 0
    display: 'directional'
  $scope.mutation = control
    id: 'mutation'
    name: 'Mutation'
    min: 0
    max: 1
    step: 0.01
    start: 0
    display: 'percent'
  $scope.maxBranchCount = control
    id: 'maxBranchCount'
    name: 'Branches'
    min: 5
    max: 1000
    step: 1
    start: 100
  $scope.branchTtl = control
    id: 'branchTtl'
    name: 'Max length'
    min: 1
    max: 3
    step: 0.05
    start: 2
    convert: 'logarithmic'
  $scope.randomization = control
    id: 'randomization'
    name: 'Randomization'
    min: 0
    max: 1
    step: 0.01
    start: 0.05
    display: 'percent'
  $scope.fillPercent = control
    id: 'fillPercent'
    name: 'Percent'
    min: 0
    max: 1
    step: 0.01
    start: 1
    display: 'percent'
  $scope.fade = control
    id: 'fade'
    name: 'Fade out'
    value: false
  $scope.branchStyle = control
    id: 'branchStyle'
    name: 'Branch style'
    start: 'random'
    options: [
        id: 'random'
        name: 'Random'
      ,
        id: 'fromStart'
        name: 'From start'
      ,
        id: 'fromEnd'
        name: 'From end'
    ]
  $scope.finishStyle = control
    id: 'finishStyle'
    name: 'Completion'
    start: 'percent'
    options: [
        id: 'percent'
        name: 'Fill screen'
        subcontrol: $scope.fillPercent
      ,
        id: 'branch'
        name: 'Draw branches'
        subcontrol: $scope.maxBranchCount
    ]
  $scope.style = control
    id: 'style'
    name: 'Style'
    start: 'weight'
    options: [
        id: 'weight'
        name: 'Wander at random'
      ,
        id: 'favorDirection'
        name: 'Favor direction'
        subcontrol: $scope.direction
      ,
        id: 'trendToCenter'
        name: 'Trend to center'
      ,
        id: 'x'
        name: 'Form an X'
      ,
        id: 'explode'
        name: 'Explode'
      ,
        id: 'jagged'
        name: 'Go jaggedly'
      ,
        id: 'squarish'
        name: 'Go squarishly'
      ,
        id: 'inertia'
        name: 'Use inertia'
        subcontrol: $scope.mutation
      ,
        id: 'bounce'
        name: 'Bounce'
        subcontrol: $scope.direction
    ]

  $scope.buttonLabel = () -> if $scope.running then 'Stop' else 'Go!'

  $scope.running = false

  $scope.$watch (-> $scope.running), (newVal) ->
    controls = $("#controls")
    if (newVal)
      controls.slideUp('slow')
      $scope.go()
    else
      $scope.grid.finish = true if $scope.grid
      controls.slideDown("slow")

  $scope.go = () ->
    c = $('#canvas')[0]

    c.width = c.clientWidth - 16
    c.height = c.clientHeight - 16
    c.style.width = c.width + 'px'
    c.style.height = c.height + 'px'

    $scope.grid = new Grid c
    $scope.grid.draw
      cellSize: 10
      strokeStyle: if $scope.fade.value then 'fade' else 'white'
      finishStyle: $scope.finishStyle.value
      directionStyle: $scope.style.value
      direction: $scope.direction.value
      branchStyle: $scope.branchStyle.value
      randomization: $scope.randomization.value
      fillPercent: $scope.fillPercent.value
      maxBranchCount: $scope.maxBranchCount.value
      branchTtl: $scope.branchTtl.value
      weight: $scope.weight.value
      speed: 0,
      onDone: -> $scope.running = false


app.directive 'toggle', ->
  restrict: 'AC'
  scope: { valueOn: '@', valueOff: '@', model: '=' }
  link: (scope, elem, attrs) ->
    scope.$watch 'model', ->
      elem.val(if scope.model then attrs.valueOn else attrs.valueOff)
    elem.bind 'click', ->
      scope.$apply -> scope.model = !scope.model

app.directive 'control', ($compile) ->
  restrict: 'A',
  scope: { control: '=', id: '@' }
  link: (scope, elem, attrs) ->
    control = scope.control
    throw "No control provided" if !attrs.control?
    return if !control?

    throw "No id provided for control" if !control.id?
    throw "No initial value provided for control #{control.id}" if control.value is undefined

    elem.attr('id', "#{control.id}Control")
    elem.addClass('control')

    if typeof control.value is 'string'
      compFunc = $compile '''
                          <div ng-repeat="opt in control.options">
                            <input type="radio" id="{{control.id}}Radio{{$index}}" name="{{control.id}}" ng-model="control.value" value="{{opt.id}}" /> {{opt.name}}
                            <div ng-show="control.value == opt.id">
                              <div control="opt.subcontrol" id="{{control.id}}_{{opt.id}}"/>
                            </div>
                          </div>
                          '''
      elem.append compFunc(scope)
    else if typeof control.value is 'boolean'
      compFunc = $compile '''
                          <div>
                            <input type="checkbox" ng-model="control.value" id="{{control.id}} "/> {{control.name}}
                          </div>
                          '''
      elem.append compFunc(scope)
    else if typeof control.value is 'number'
      compFunc = $compile """
            <div>
              {{control.name}}: <span id="{{control.id}}Text" class="text">{{control.displayText}}</span><br/>
              <div class="slider">
                <div id="{{control.id}}Slide"></div>
              </div>
              <input type="text" id="{{control.id}}" class="model" value="{{control.value}}" style="display:none"/>
            </div>
            """
      elem.append compFunc(scope)
      elem.find('.slider div:first').slider
        #value: control.value
        min: parseInt control.min
        max: parseInt control.max
        step: parseFloat control.step
        value: control.value
        slide: (event, ui) ->
          scope.$apply -> control.setValue ui.value

      control.setValue control.value