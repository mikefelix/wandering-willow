// Generated by CoffeeScript 1.4.0
var argInits, argNames, directions, go, onSelectDir, onSelectFinish, showVal, startGrid;

argNames = {
  favorDirection: 'Direction',
  inertia: 'Mutation rate',
  x: 'Width',
  bounce: 'Start direction'
};

argInits = {
  favorDirection: 0,
  inertia: 0,
  x: 30,
  bounce: 0
};

directions = ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest'];

startGrid = function() {
  var area, c;
  c = $('#canvas')[0];
  area = $('#drawArea')[0];
  c.width = area.clientWidth - 16;
  c.height = area.clientHeight - 56;
  c.style.width = c.width + 'px';
  c.style.height = c.height + 'px';
  return window.grid = new Grid(c);
};

go = function() {
  var finishStyle, opts, slide;
  slide = directionalArgSlide ? $('#dirArg') : $('#arg');
  opts = {
    strokeStyle: $('#fade')[0].checked ? 'fade' : 'white',
    cellSize: 10,
    directionStyle: $('#directionStyle').val(),
    directionArg: slide.val(),
    branchStyle: $('#branchStyle').val(),
    weight: Math.abs(parseFloat($('#weight').val()) - 1),
    branchTtl: $('#branchTtl').val(),
    speed: 0,
    onDone: function() {
      return $('#go').val('Go!');
    }
  };
  finishStyle = $('#finishStyle').val();
  if (finishStyle === 'percent') {
    opts['fillPercent'] = $('#fillPercent').val() / 100;
  } else {
    opts['maxBranchCount'] = $('#maxBranchCount').val();
  }
  return window.grid.draw(opts);
};

onSelectDir = function() {
  var directionalArgSlide, name, type;
  type = $('#directionStyle').val();
  name = argNames[type];
  directionalArgSlide = type === 'favorDirection' || type === 'bounce';
  if (name != null) {
    if (directionalArgSlide) {
      $('#argSection').hide();
      $('#dirArg').val(argInits[type]);
      $('#dirArgSection').show();
      return $('#dirArgName').html(name + ":");
    } else {
      $('#dirArgSection').hide();
      $('#arg').val(argInits[type]);
      $('#argSection').show();
      return $('#argName').html(name + ":");
    }
  } else {
    $('#arg').val('');
    $('#argSection').hide();
    $('#dirArg').val('');
    return $('#dirArgSection').hide();
  }
};

onSelectFinish = function() {
  var sel;
  sel = $('#finishStyle')[0];
  if (sel.selectedIndex === 0) {
    $('#maxBranchCtrl').hide();
    return $('#fillPercentCtrl').show();
  } else {
    $('#fillPercentCtrl').hide();
    return $('#maxBranchCtrl').show();
  }
};

showVal = function(id, val, text) {
  var span;
  $("#" + id).val(val);
  span = $("#" + id + "_text");
  if (span) {
    return span.html(text != null ? text : {
      text: val
    });
  }
};

$(function() {
  $('#directionStyle').change(onSelectDir);
  $('#finishStyle').change(onSelectFinish);
  $('#argSlide').slider({
    min: 5,
    max: 100,
    value: 10,
    step: 1,
    slide: function(event, ui) {
      return showVal('arg', ui.value);
    }
  });
  $('#dirArgSlide').slider({
    min: 0,
    max: 7,
    value: 0,
    step: 1,
    slide: function(event, ui) {
      return showVal('dirArg', ui.value, directions[ui.value]);
    }
  });
  $('#maxBranchSlide').slider({
    min: 5,
    max: 1000,
    value: 100,
    step: 1,
    slide: function(event, ui) {
      return showVal('maxBranchCount', ui.value);
    }
  });
  $('#branchTtlSlide').slider({
    min: 1,
    max: 5,
    value: 2,
    step: 0.1,
    slide: function(event, ui) {
      var ttl;
      ttl = Math.floor(Math.pow(10, ui.value));
      return showVal('branchTtl', ttl);
    }
  });
  $('#weightSlide').slider({
    min: 0,
    max: 0.5,
    value: 0.1,
    step: 0.01,
    slide: function(event, ui) {
      return showVal('weight', ui.value);
    }
  });
  $('#fillPercentSlide').slider({
    min: 0,
    max: 1,
    value: 1,
    step: 0.01,
    slide: function(event, ui) {
      return showVal('fillPercent', ui.value * 100);
    }
  });
  $('#go').click(function() {
    var controls;
    controls = $("#controls");
    if (controls.is(":hidden")) {
      window.grid.finish = true;
      controls.slideDown("slow");
      return $('#go').val('Go');
    } else {
      controls.slideUp('slow');
      $('#go').val('Stop');
      return go();
    }
  });
  onSelectDir();
  onSelectFinish();
  return startGrid();
});
