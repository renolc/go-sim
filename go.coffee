class GoGame
	# properties
	canvas         : null
	drawingContext : null
	images         : null
	board          : null
	mousePosition  : null

	# enums and constants
	cellSize       : 20
	boardSize      : 19
	FPS            : 30

	Images =
		INERSECTION : 'int'
		TOPLEFT     : 'tl'
		TOPRIGHT    : 'tr'
		BOTTOMLEFT  : 'bl'
		BOTTOMRIGHT : 'br'
		TOP         : 't'
		RIGHT       : 'r'
		BOTTOM      : 'b'
		LEFT        : 'l'
		BLACK       : 'black'
		WHITE       : 'white'

	constructor : ->
		@initCanvasAndContext()
		@initBoard()

		@loadImagesAndDraw()

	initCanvasAndContext : ->
		@canvas = document.createElement('canvas')
		@canvas.height = @cellSize * @boardSize
		@canvas.width  = @canvas.height
		@drawingContext = @canvas.getContext('2d')
		document.body.appendChild(@canvas)

		@canvas.onmousemove = (e) =>
			if e.offsetX
				@mousePosition =
					x : Math.floor(e.offsetX / @cellSize) * @cellSize
					y : Math.floor(e.offsetY / @cellSize) * @cellSize
			else if e.layerX
				@mousePosition =
					x : Math.floor(e.layerX / @cellSize) * @cellSize
					y : Math.floor(e.layerY / @cellSize) * @cellSize

	initBoard : ->
		@board = []

		for row in [0...@boardSize]
			@board[row] = []

			for col in [0...@boardSize]
				@board[row][col] = @createCell(row, col)

	createCell : (row, col) ->
		piece : null
		row   : row
		col   : col
		x     : col * @cellSize
		y     : row * @cellSize

	loadImagesAndDraw : ->
		@images = []

		@images[Images.TOP]         = new Image()
		@images[Images.RIGHT]       = new Image()
		@images[Images.BOTTOM]      = new Image()
		@images[Images.LEFT]        = new Image()
		@images[Images.TOPRIGHT]    = new Image()
		@images[Images.TOPLEFT]     = new Image()
		@images[Images.BOTTOMRIGHT] = new Image()
		@images[Images.BOTTOMLEFT]  = new Image()
		@images[Images.INERSECTION] = new Image()
		@images[Images.BLACK]       = new Image()
		@images[Images.WHITE]       = new Image()

		imagesLoadedCount = 0
		for k,v of @images
			imagesLoadedCount++
			v.onload = =>
				imagesLoadedCount--
				if imagesLoadedCount == 0
					@draw()

		@images[Images.TOP].src         = 'img/topEdge.png'
		@images[Images.RIGHT].src       = 'img/rightEdge.png'
		@images[Images.BOTTOM].src      = 'img/bottomEdge.png'
		@images[Images.LEFT].src        = 'img/leftEdge.png'
		@images[Images.TOPRIGHT].src    = 'img/topRight.png'
		@images[Images.TOPLEFT].src     = 'img/topLeft.png'
		@images[Images.BOTTOMRIGHT].src = 'img/bottomRight.png'
		@images[Images.BOTTOMLEFT].src  = 'img/bottomLeft.png'
		@images[Images.INERSECTION].src = 'img/intersection.png'
		@images[Images.BLACK].src       = 'img/black.png'
		@images[Images.WHITE].src       = 'img/white.png'

	draw : ->
		# clear and board color fill
		fillStyle = 'rgb(195, 142, 72)'
		@drawingContext.fillStyle = fillStyle
		@drawingContext.fillRect(0, 0, @canvas.width, @canvas.height)

		# draw individual cells
		for row in [0...@boardSize]
			for col in [0...@boardSize]
				@drawCell(@board[row][col])

		if @mousePosition
			@drawingContext.drawImage(@images[Images.BLACK], @mousePosition.x, @mousePosition.y, @cellSize, @cellSize)

		# loop the draw call
		setTimeout((=> @draw()), 1000/@FPS)

	drawCell : (cell) ->
		if cell.row == 0 and cell.col == 0
			img = @images[Images.TOPLEFT]
		else if cell.row == 0 and cell.col == @boardSize - 1
			img = @images[Images.TOPRIGHT]
		else if cell.row == @boardSize - 1 and cell.col == 0
			img = @images[Images.BOTTOMLEFT]
		else if cell.row == @boardSize - 1 and cell.col == @boardSize - 1
			img = @images[Images.BOTTOMRIGHT]
		else if cell.row == 0
			img = @images[Images.TOP]
		else if cell.row == @boardSize - 1
			img = @images[Images.BOTTOM]
		else if cell.col == 0
			img = @images[Images.LEFT]
		else if cell.col == @boardSize - 1
			img = @images[Images.RIGHT]
		else
			img = @images[Images.INERSECTION]

		@drawingContext.drawImage(img, cell.x, cell.y, @cellSize, @cellSize)

# DOM is ready
window.onload = -> new GoGame()