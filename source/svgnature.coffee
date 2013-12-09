(($, window, document) ->
  class Svgnature
    constructor: (el, settings) ->
      @settings = settings
      @paper = Raphael(el)
      @coords = ''

      $(el).on('mousedown', @drawStart)
        .on('mouseup', @drawEnd)
        .on('mousemove', @move)
        .on('touchstart', @drawStart)
        .on('touchend', @drawEnd)
        .on('touchmove', @move)

    getCoords: (e) ->
      if e.touches
        x: e.touches[0].clientX
        y: e.touches[0].clientY
      else if e.originalEvent?.touches?
        x: e.originalEvent.touches[0].clientX
        y: e.originalEvent.touches[0].clientY
      else
        x: e.offsetX
        y: e.offsetY

    drawStart: (e) ->
      $(this).data('svgnature').initializeLine(e)

    move: (e) ->
      e.preventDefault()
      $(this).data('svgnature').drawLine(e) 

    drawEnd: (e) ->
      $(this).data('svgnature').drawing = false

    initializeLine: (e) ->
      @drawing = true
      @path ||= @paper.path().attr(@settings)
      @setNextCoord('M', @getCoords(e))

    drawLine: (e) ->
      if @drawing
        @setNextCoord('L', @getCoords(e))
        @path.attr('path', @getPath())

    setNextCoord: (command, coords) ->
      @coords = "#{@coords}#{command}#{coords.x},#{coords.y}"

    addPath: (path) ->
      @coords = "#{@coords}#{path}"
      @path.attr('path', @coords)
      true

    getPath: ->
      @coords

    clearPath: ->
      @coords = ''
      @path.attr('path', '')
      true

    getURI: ->
      serializer = new XMLSerializer
      "data:image/svg+xml;utf8,#{serializer.serializeToString(@paper.canvas)}"

  $.fn.svgnature = (method, args...) ->
    $(this).map (i, el) ->
      svgnature = $(el).data('svgnature')

      if method == 'getURI'
        svgnature.getURI()
      else if method == 'getPath'
        svgnature.getPath()
      else if method == 'addPath'
        svgnature.addPath(args[i])
      else if method == 'clearPath'
        svgnature.clearPath()
      else
        defaults =
          'stroke': '#000'
          'stroke-width': '2'

        settings = $.extend(defaults, method)
        $(el).data('svgnature', new Svgnature(el, settings))

)(jQuery, window, document)
