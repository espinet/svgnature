(($, window, document, undefined) ->
  getCoords = (e) ->
    $el = $(this)

    if e.touches
      x: e.touches[0].clientX
      y: e.touches[0].clientY
    else if e.originalEvent?.touches?
      x: e.originalEvent.touches[0].clientX
      y: e.originalEvent.touches[0].clientY
    else
      x: e.offsetX
      y: e.offsetY

  drawStart = (e) ->
    $el = $(this)
    $el.data('drawing.svgnature', true)
    $el.data('pathObj.svgnature', createNewPath($el)) unless $el.data('pathObj.svgnature')

    setNextCoord($el, 'M', getCoords(e))

  move = (e) ->
    e.preventDefault()
    drawLine($(this), getCoords(e)) if $el.data('drawing.svgnature')

  drawEnd = (e) ->
    $(this.)data('drawing.svgnature', false)

  drawLine = ($el, coords) ->
    $el.data('pathObj.svgnature').attr('path', setNextCoord($el, 'L', coords))

  createNewPath = ($el) ->
    settings = $el.data('settings.svgnature')
    $el.data('paper.svgnature').path().attr(settings)

  setNextCoord = ($el, command, coords) ->
    oldPath = $el.data('coords.svgnature')
    $el.data('coords.svgnature', "#{oldPath}#{command}#{coords.x},#{coords.y}")
    $el.data('coords.svgnature')

  addPath = (elements, path) ->
    elements.each (i, el) =>
      oldPath = $(el).data('coords.svgnature')
      newPath = "#{oldPath}#{path}"
      $(el).data('coords.svgnature', newPath)
      $(el).data('pathObj.svgnature').attr('path', newPath)

  getPath = (elements) ->
    elements.map (i, el) ->
      $(el).data('coords.svgnature')

  clearPath = (elements) ->
    elements.each (i, el) ->
      $(el).data('coords.svgnature', '')
      $(el).data('pathObj.svgnature').attr('path', '')

  getURI = (elements) ->
    elements.map (i, el) ->
      $el = $(el)
      paper = $el.data('paper.svgnature')
      serializer = new XMLSerializer
      "data:image/svg+xml;utf8,#{serializer.serializeToString(paper.canvas)}"

  initialize = (elements, settings) ->
    elements.each (i, el) =>
      paper = Raphael(el)
      $(el).data('settings.svgnature', settings)

      $(el).on('mousedown.svgnature', drawStart)
      $(el).on('mouseup.svgnature', drawEnd)
      $(el).on('mousemove.svgnature', move)
       
      $(el).on('touchstart.svgnature', drawStart)
      $(el).on('touchend.svgnature', drawEnd)
      $(el).on('touchmove.svgnature', move)
       
      $(el).data('paper.svgnature', paper)

  $.fn.svgnature = (method, args...) ->
    elements = $(this)
    if method == 'getURI'
      getSVG(elements)
    else if method == 'getPath'
      getPath(elements)
    else if method == 'addPath'
      addPath(elements, args[0])
    else if method == 'clearPath'
      clearPath(elements)
    else
      defaults =
        'stroke': '#000'
        'stroke-width': '2'

      settings = $.extend(defaults, method)
      initialize(elements, settings)

)(jQuery, window, document, undefined)
