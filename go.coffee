class GoGame
	# properties ######################################################
	canvas         : null
	drawingContext : null
	board          : null
	mousePosition  : null

	# enums and constants #############################################
	cellSize     : 20
	boardSize    : 19
	FPS          : 30
	currentAlpha : 0.5

	# images ##########################################################
	Images =
		INERSECTION : null
		TOPLEFT     : null
		TOPRIGHT    : null
		BOTTOMLEFT  : null
		BOTTOMRIGHT : null
		TOP         : null
		RIGHT       : null
		LEFT        : null
		BOTTOM      : null
		BLACK       : null
		WHITE       : null

	# init functions ##################################################
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

		@canvas.onmousemove = @onMouseMove

		@canvas.onclick = @onMouseClick

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

		Images.TOP         = new Image()
		Images.RIGHT       = new Image()
		Images.BOTTOM      = new Image()
		Images.LEFT        = new Image()
		Images.TOPRIGHT    = new Image()
		Images.TOPLEFT     = new Image()
		Images.BOTTOMRIGHT = new Image()
		Images.BOTTOMLEFT  = new Image()
		Images.INERSECTION = new Image()
		Images.BLACK       = new Image()
		Images.WHITE       = new Image()

		# count the number of images and wait until they all
		# are loaded before issuing the first draw call
		imagesLoadedCount = 0
		for k,v of Images
			imagesLoadedCount++
			v.onload = =>
				imagesLoadedCount--
				if imagesLoadedCount == 0
					@draw()

		Images.TOP.src         = 'img/topEdge.png'
		Images.RIGHT.src       = 'img/rightEdge.png'
		Images.BOTTOM.src      = 'img/bottomEdge.png'
		Images.LEFT.src        = 'img/leftEdge.png'
		Images.TOPRIGHT.src    = 'img/topRight.png'
		Images.TOPLEFT.src     = 'img/topLeft.png'
		Images.BOTTOMRIGHT.src = 'img/bottomRight.png'
		Images.BOTTOMLEFT.src  = 'img/bottomLeft.png'
		Images.INERSECTION.src = 'img/intersection.png'
		Images.BLACK.src       = 'img/black.png'
		Images.WHITE.src       = 'img/white.png'

	# draw functions ##################################################
	draw : ->
		# clear and board color fill
		fillStyle = 'rgb(195, 142, 72)'
		@drawingContext.fillStyle = fillStyle
		@drawingContext.fillRect(0, 0, @canvas.width, @canvas.height)

		# draw individual cells
		for row in [0...@boardSize]
			for col in [0...@boardSize]
				@drawCell(@board[row][col])

		# draw the current piece with half transparency
		@drawCurrentPiece()

		# loop the draw call
		setTimeout((=> @draw()), 1000/@FPS)

	drawCurrentPiece : ->
		if @mousePosition
			@drawingContext.save()
			@drawingContext.globalAlpha = @currentAlpha
			@drawingContext.drawImage(Images.BLACK, @mousePosition.x,
				@mousePosition.y, @cellSize, @cellSize)
			@drawingContext.restore()

	drawCell : (cell) ->
		# draw the correct intersection
		if cell.row == 0 and cell.col == 0
			img = Images.TOPLEFT
		else if cell.row == 0 and cell.col == @boardSize - 1
			img = Images.TOPRIGHT
		else if cell.row == @boardSize - 1 and cell.col == 0
			img = Images.BOTTOMLEFT
		else if cell.row == @boardSize - 1 and cell.col == @boardSize - 1
			img = Images.BOTTOMRIGHT
		else if cell.row == 0
			img = Images.TOP
		else if cell.row == @boardSize - 1
			img = Images.BOTTOM
		else if cell.col == 0
			img = Images.LEFT
		else if cell.col == @boardSize - 1
			img = Images.RIGHT
		else
			img = Images.INERSECTION
		
		@drawingContext.drawImage(img, cell.x, cell.y, @cellSize,
			@cellSize)

		# draw the cell piece, if it has any
		if cell.piece
			@drawingContext.drawImage(cell.piece, cell.x, cell.y, @cellSize,
				@cellSize)

	# handler functions ###############################################
	onMouseMove : (e) =>
		# snap the x and y positions to the closest cell
		if e.offsetX
			col = Math.floor(e.offsetX / @cellSize)
			row = Math.floor(e.offsetY / @cellSize)
			@mousePosition =
				cellCol : col
				cellRow : row
				x       : col * @cellSize
				y       : row * @cellSize
		else if e.layerX
			col = Math.floor(e.layerX / @cellSize)
			row = Math.floor(e.layerY / @cellSize)
			@mousePosition =
				cellCol : col
				cellRow : row
				x       : col * @cellSize
				y       : row * @cellSize

	onMouseClick : =>
		cell = @board[@mousePosition.cellRow][@mousePosition.cellCol]
		cell.piece = Images.BLACK

# DOM is ready
window.onload = -> new GoGame()