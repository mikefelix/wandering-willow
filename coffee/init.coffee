argNames =
  favorDirection: 'Direction',
  inertia: 'Mutation rate',
  x: 'Width',
  bounce: 'Start direction'

argInits =
  favorDirection: 0,
  inertia: 0,
  x: 30,
  bounce: 0

directions = ['North', 'Northeast', 'East', 'Southeast', 'South', 'Southwest', 'West', 'Northwest']

startGrid = () ->
  c = $('#canvas')[0]
  area = $('#drawArea')[0]
  
  c.width = area.clientWidth - 16
  c.height = area.clientHeight - 56
  c.style.width = c.width + 'px'
  c.style.height = c.height + 'px'
  
  window.grid = new Grid(c)

go = () ->
  slide = if directionalArgSlide then $('#dirArg') else $('#arg')
  opts =
    strokeStyle: if $('#fade')[0].checked then 'fade' else 'white',
    cellSize: 10,
    directionStyle: $('#directionStyle').val(),
    directionArg: slide.val(),
    branchStyle: $('#branchStyle').val(),
    weight: Math.abs(parseFloat($('#weight').val()) - 1),
    branchTtl: $('#branchTtl').val(),
    speed: 0,
    onDone: -> $('#go').val('Go!')

  finishStyle = $('#finishStyle').val()
  if (finishStyle == 'percent')
    opts['fillPercent'] = $('#fillPercent').val() / 100
  else
    opts['maxBranchCount'] = $('#maxBranchCount').val()

  window.grid.draw opts

onSelectDir = () ->
  type = $('#directionStyle').val()
  name = argNames[type]
  directionalArgSlide = (type == 'favorDirection' || type == 'bounce')

  if name?
    if directionalArgSlide
      $('#argSection').hide()
      $('#dirArg').val(argInits[type])
      $('#dirArgSection').show()
      $('#dirArgName').html(name + ":")
    else
      $('#dirArgSection').hide()
      $('#arg').val(argInits[type])
      $('#argSection').show()
      $('#argName').html(name + ":")
  else 
    $('#arg').val('')
    $('#argSection').hide()
    $('#dirArg').val('')
    $('#dirArgSection').hide()

onSelectFinish = () ->
  sel = $('#finishStyle')[0]
  if (sel.selectedIndex == 0) 
    $('#maxBranchCtrl').hide()
    $('#fillPercentCtrl').show()
  else 
    $('#fillPercentCtrl').hide()
    $('#maxBranchCtrl').show()

showVal = (id, val, text) ->
  $("#" + id).val(val)
  span = $("#" + id + "_text")
  if (span)
    span.html(text ? text : val)

$ ->
  $('#directionStyle').change(onSelectDir)
  $('#finishStyle').change(onSelectFinish)
  $('#argSlide').slider
    min: 5,
    max: 100,
    value: 10,
    step: 1,
    slide: (event, ui) -> showVal 'arg', ui.value
  
  $('#dirArgSlide').slider
    min: 0,
    max: 7,
    value: 0,
    step: 1,
    slide: (event, ui) -> showVal 'dirArg', ui.value, directions[ui.value]

  $('#maxBranchSlide').slider
    min: 5,
    max: 1000,
    value: 100,
    step: 1,
    slide: (event, ui) -> showVal 'maxBranchCount', ui.value
  
  $('#branchTtlSlide').slider
    min: 1,
    max: 5,
    value: 2,
    step: 0.1,
    slide: (event, ui) ->
      ttl = Math.floor(Math.pow 10, ui.value)
      showVal 'branchTtl', ttl

  $('#weightSlide').slider
    min: 0,
    max: 0.5,
    value: 0.1,
    step: 0.01,
    slide: (event, ui) -> showVal 'weight', ui.value
  
  $('#fillPercentSlide').slider
    min: 0,
    max: 1,
    value: 1,
    step: 0.01,
    slide: (event, ui) -> showVal 'fillPercent', ui.value * 100
  
  $('#go').click ->
    controls = $("#controls")
    if (controls.is(":hidden"))
      window.grid.finish = true
      controls.slideDown("slow")
      $('#go').val('Go')
    else
      controls.slideUp('slow')
      $('#go').val('Stop')
      go()

  onSelectDir()
  onSelectFinish()
  startGrid()