class ImageViewer
  scale: 1.0
  zoomStep: 100 # amount to zoom per click
  initialWidth: 0
  position: {x: 0, y: 0}
  dragOffset: null

  constructor: (shell) ->
    @shell = $(shell)
    @image = @shell.find('img')
    @bindControls()

  bindControls: () =>
    @shell.on 'mousewheel', @onScroll

    @shell.on 'mousedown', (event) =>
      event.stopPropagation()
      event.preventDefault()
      @shell.bind 'mousemove.drag', @drag
    @shell.on 'mouseup', (event) =>
      event.stopPropagation()
      event.preventDefault()
      @stopDrag()
    @shell.on 'mouseout', (event) =>
      @stopDrag()

    @shell.on 'dblclick', (event) =>
      event.stopPropagation()
      event.preventDefault()
      @zoom(@zoomStep)

  onScroll: (event) =>
    event.stopPropagation()
    event.preventDefault()

    originalEvent = event.originalEvent
    delta = originalEvent.wheelDelta or (-40 * originalEvent.detail)
    @zoom(delta, {x: event.pageX, y: event.pageY})

  zoom: (amount, mousePosition = {x: 0, y: 0}) =>
    @initialWidth = @image.width() if @initialWidth == 0
    amount /= 120
    power = if amount > 0 then 1 else -1
    zoom = Math.pow(1+Math.abs(amount)/2, power)
    scale = @scale * zoom

    return if scale * @initialWidth < 10 || scale > 100

    @scale = scale

    offset = {
      x: mousePosition.x - @position.x
      y: mousePosition.y - @position.y
    }
    # Ratio of where the cursor is on the image
    ratio = {
      x: offset.x / @image.width()
      y: offset.y / @image.height()
    }

    # Resize then find new position
    @image.attr('width', @scale * @initialWidth)
    @position = {
      x: Math.floor(mousePosition.x - (@image.width() * ratio.x))
      y: Math.floor(mousePosition.y - (@image.height() * ratio.y))
    }

    @updateImagePosition()

  drag: (event) =>
    @dragOffset ?= {
      x: event.pageX - @position.x
      y: event.pageY - @position.y
    }

    @position = {
      x: event.pageX - @dragOffset.x
      y: event.pageY - @dragOffset.y
    }

    @updateImagePosition()

  updateImagePosition: () =>
    @image.css('left', @position.x)
    @image.css('top', @position.y)

  stopDrag: () =>
    @dragOffset = null
    @shell.unbind('.drag')
