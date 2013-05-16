app = angular.module 'WillowApp', []

app.value 'directions', ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest']

app.controller 'WillowCtrl', ($scope, directions) ->
  $scope.branchTtl = 100
  $scope.logarithmic = (value) -> Math.floor(Math.pow(10, value))
  $scope.directional = (value) -> directions[value]
  $scope.unchanged = (a) -> a

app.directive 'slider', ->
  restrict: 'E',
  replace: true,
  scope:
    text: '@'
    id: '@'
    min: '@'
    max: '@'
    step: '@'
    model: '='
    convertValue: '='
    displayValue: '='
  template: """
           <div id="{{id}}Control" class="control">
              {{text}}: <span id="{{id}}Text" class="text">{{displayText}}</span><br/>
              <div class="slider">
                <div id="{{id}}Slide"></div>
              </div>
              <input type="text" id="{{id}}" class="model" value="{{model}}" size="4"/>
           </div>
           """
  link: (scope, elem, attrs) ->
    display = ->
      scope.displayText = scope.displayValue scope.model

    (elem.find '.slider div:first').slider
      min: attrs.min
      max: attrs.max
      value: scope.model
      step: scope.step
      slide: (event, ui) ->
        scope.$apply ->
          scope.model = scope.convertValue ui.value
          display()
