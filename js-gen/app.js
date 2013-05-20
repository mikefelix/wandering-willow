// Generated by CoffeeScript 1.6.2
var app;

app = angular.module('WillowApp', []);

app.value('directions', ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest']);

app.factory('control', function(directions) {
  return function(opts) {
    var convertFuncs, displayFuncs;

    convertFuncs = {
      logarithmic: function(value) {
        return Math.floor(Math.pow(10, value));
      },
      percent: function(value) {
        return value * 100;
      }
    };
    displayFuncs = {
      directional: function(value) {
        return directions[value];
      },
      percent: function(value) {
        return Math.floor(value * 100) + '%';
      },
      formatted: function(value) {
        var i, j, q, sign;

        sign = value < 0 ? "-" : "";
        i = parseInt(Math.abs(+value || 0).toFixed(2)) + "";
        j = i.length > 3 ? i.length % 3 : 0;
        q = j ? i.substr(0, j) + ',' : '';
        return sign + q + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + ',');
      }
    };
    return {
      id: opts.id,
      name: opts.name,
      min: opts.min,
      max: opts.max,
      step: opts.step,
      value: opts.start === void 0 ? opts.value : opts.start,
      options: opts.options,
      convert: convertFuncs[opts.convert] || function(a) {
        return a;
      },
      display: displayFuncs[opts.display] || function(a) {
        return a;
      },
      setValue: function(v) {
        this.value = this.convert(v);
        return this.displayText = this.display(this.value);
      }
    };
  };
});

app.controller('WillowCtrl', function($scope, control) {
  $scope.direction = control({
    id: 'direction',
    name: 'Direction',
    min: 0,
    max: 7,
    step: 1,
    start: 0,
    display: 'directional'
  });
  $scope.mutation = control({
    id: 'mutation',
    name: 'Mutation',
    min: 0,
    max: 1,
    step: 0.01,
    start: 0,
    display: 'percent'
  });
  $scope.maxBranchCount = control({
    id: 'maxBranchCount',
    name: 'Branches',
    min: 5,
    max: 1000,
    step: 1,
    start: 100
  });
  $scope.branchTtl = control({
    id: 'branchTtl',
    name: 'Max length',
    min: 1,
    max: 3,
    step: 0.05,
    start: 2,
    convert: 'logarithmic'
  });
  $scope.randomization = control({
    id: 'randomization',
    name: 'Randomization',
    min: 0,
    max: 1,
    step: 0.01,
    start: 0.05,
    display: 'percent'
  });
  $scope.fillPercent = control({
    id: 'fillPercent',
    name: 'Percent',
    min: 0,
    max: 1,
    step: 0.01,
    start: 1,
    display: 'percent'
  });
  $scope.fade = control({
    id: 'fade',
    name: 'Fade out',
    value: false
  });
  $scope.branchStyle = control({
    id: 'branchStyle',
    name: 'Branch style',
    start: 'random',
    options: [
      {
        id: 'random',
        name: 'Random'
      }, {
        id: 'fromStart',
        name: 'From start'
      }, {
        id: 'fromEnd',
        name: 'From end'
      }
    ]
  });
  $scope.finishStyle = control({
    id: 'finishStyle',
    name: 'Completion',
    start: 'percent',
    options: [
      {
        id: 'percent',
        name: 'Fill screen',
        subcontrol: $scope.fillPercent
      }, {
        id: 'branch',
        name: 'Draw branches',
        subcontrol: $scope.maxBranchCount
      }
    ]
  });
  $scope.style = control({
    id: 'style',
    name: 'Style',
    start: 'weight',
    options: [
      {
        id: 'weight',
        name: 'Wander at random'
      }, {
        id: 'favorDirection',
        name: 'Favor direction',
        subcontrol: $scope.direction
      }, {
        id: 'trendToCenter',
        name: 'Trend to center'
      }, {
        id: 'x',
        name: 'Form an X'
      }, {
        id: 'explode',
        name: 'Explode'
      }, {
        id: 'jagged',
        name: 'Go jaggedly'
      }, {
        id: 'squarish',
        name: 'Go squarishly'
      }, {
        id: 'inertia',
        name: 'Use inertia',
        subcontrol: $scope.mutation
      }, {
        id: 'bounce',
        name: 'Bounce',
        subcontrol: $scope.direction
      }
    ]
  });
  $scope.buttonLabel = function() {
    if ($scope.running) {
      return 'Stop';
    } else {
      return 'Go!';
    }
  };
  $scope.running = false;
  $scope.$watch((function() {
    return $scope.running;
  }), function(newVal) {
    var controls;

    controls = $("#controls");
    if (newVal) {
      controls.slideUp('slow');
      return $scope.go();
    } else {
      if ($scope.grid) {
        $scope.grid.finish = true;
      }
      return controls.slideDown("slow");
    }
  });
  return $scope.go = function() {
    $scope.grid = new Grid($('#canvas')[0]);
    return $scope.grid.draw({
      cellSize: 10,
      strokeStyle: $scope.fade.value ? 'fade' : 'white',
      directionStyle: $scope.style.value,
      direction: $scope.direction.value,
      branchStyle: $scope.branchStyle.value,
      randomization: $scope.randomization.value,
      fillPercent: $scope.fillPercent.value,
      maxBranchCount: $scope.maxBranchCount.value,
      branchTtl: $scope.branchTtl.value,
      speed: 0,
      onDone: function() {
        return $scope.running = false;
      }
    });
  };
});

app.directive('toggle', function() {
  return {
    restrict: 'AC',
    scope: {
      valueOn: '@',
      valueOff: '@',
      model: '='
    },
    link: function(scope, elem, attrs) {
      scope.$watch('model', function() {
        return elem.val(scope.model ? attrs.valueOn : attrs.valueOff);
      });
      return elem.bind('click', function() {
        return scope.$apply(function() {
          return scope.model = !scope.model;
        });
      });
    }
  };
});

app.directive('control', function($compile) {
  return {
    restrict: 'A',
    scope: {
      control: '=',
      id: '@'
    },
    link: function(scope, elem, attrs) {
      var compFunc, control;

      control = scope.control;
      if (attrs.control == null) {
        throw "No control provided";
      }
      if (control == null) {
        return;
      }
      if (control.id == null) {
        throw "No id provided for control";
      }
      if (control.value === void 0) {
        throw "No initial value provided for control " + control.id;
      }
      elem.attr('id', "" + control.id + "Control");
      elem.addClass('control');
      if (typeof control.value === 'string') {
        compFunc = $compile('<div ng-repeat="opt in control.options">\n  <input type="radio" id="{{control.id}}Radio{{$index}}" name="{{control.id}}" ng-model="control.value" value="{{opt.id}}" /> {{opt.name}}\n  <div ng-show="control.value == opt.id">\n    <div control="opt.subcontrol" id="{{control.id}}_{{opt.id}}"/>\n  </div>\n</div>');
        return elem.append(compFunc(scope));
      } else if (typeof control.value === 'boolean') {
        compFunc = $compile('<div>\n  <input type="checkbox" ng-model="control.value" id="{{control.id}} "/> {{control.name}}\n</div>');
        return elem.append(compFunc(scope));
      } else if (typeof control.value === 'number') {
        compFunc = $compile("<div>\n  {{control.name}}: <span id=\"{{control.id}}Text\" class=\"text\">{{control.displayText}}</span><br/>\n  <div class=\"slider\">\n    <div id=\"{{control.id}}Slide\"></div>\n  </div>\n  <input type=\"text\" id=\"{{control.id}}\" class=\"model\" value=\"{{control.value}}\" style=\"display:none\"/>\n</div>");
        elem.append(compFunc(scope));
        elem.find('.slider div:first').slider({
          min: parseInt(control.min),
          max: parseInt(control.max),
          step: parseFloat(control.step),
          value: control.value,
          slide: function(event, ui) {
            return scope.$apply(function() {
              return control.setValue(ui.value);
            });
          }
        });
        return control.setValue(control.value);
      }
    }
  };
});
