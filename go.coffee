class GoGame
	# properties ######################################################
	DEBUG          : null
	canvas         : null
	drawingContext : null
	board          : null
	mousePosition  : null
	turn           : null
	clusters       : null

	# enums and constants #############################################
	cellSize     : 20
	boardSize    : 19
	FPS          : 30
	currentAlpha : 0.5

	Position =
		UP    : 'up'
		DOWN  : 'down'
		LEFT  : 'left'
		RIGHT : 'right'

	# images ##########################################################
	Images =
		INERSECTION   : new Image()
		TOPLEFT       : new Image()
		TOPRIGHT      : new Image()
		BOTTOMLEFT    : new Image()
		BOTTOMRIGHT   : new Image()
		TOP           : new Image()
		RIGHT         : new Image()
		LEFT          : new Image()
		BOTTOM        : new Image()
		BLACK         : new Image()
		WHITE         : new Image()
		DEBUG_LIBERTY : new Image()

	# init functions ##################################################
	constructor : (debug = false) ->
		@DEBUG = debug
		
		@initCanvasAndContext()
		@initBoard()

		@loadImagesAndDraw()

	initCanvasAndContext : ->
		@canvas = document.createElement('canvas')
		@canvas.height = @canvas.width = @cellSize * @boardSize
		@drawingContext = @canvas.getContext('2d')
		document.body.appendChild(@canvas)

		# setup handlers
		@canvas.onmousemove = @onMouseMove
		@canvas.onclick = @onMouseClick
		@canvas.onmouseout = @onMouseOut

	initBoard : ->
		# black goes first
		@turn = Images.BLACK

		@clusters = []
		@board = []

		for row in [0...@boardSize]
			@board[row] = []

			for col in [0...@boardSize]
				@board[row][col] = @createCell(row, col)

	createCell : (row, col) ->
		piece   : null
		cluster : null
		row     : row
		col     : col

		getNeighbors : =>
			cell = @board[row][col]
			neighbors = []
			for k, v of Position
				neighbors.push(cell.getNeighbor(v))
			neighbors

		getNeighbor : (position) =>
			switch position
				when Position.UP
					@board[row-1]?[col]
				when Position.DOWN
					@board[row+1]?[col]
				when Position.LEFT
					@board[row][col-1]
				when Position.RIGHT
					@board[row][col+1]

		setCluster : (cluster) =>
			cell = @board[row][col]
			cell.cluster = cluster
			@addCellToCluster(cell, cluster)

	createCluster : (cell) ->
		cells     : [cell]
		liberties : []

	loadImagesAndDraw : ->
		# count the number of images and wait until they all
		# are loaded before issuing the first draw call
		imagesLoadedCount = 0
		for k,v of Images
			imagesLoadedCount++
			v.onload = =>
				imagesLoadedCount--
				if imagesLoadedCount == 0
					@draw()

		# set all the image sources which kicks off the loading
		Images.TOP.src           = 'img/topEdge.png'
		Images.RIGHT.src         = 'img/rightEdge.png'
		Images.BOTTOM.src        = 'img/bottomEdge.png'
		Images.LEFT.src          = 'img/leftEdge.png'
		Images.TOPRIGHT.src      = 'img/topRight.png'
		Images.TOPLEFT.src       = 'img/topLeft.png'
		Images.BOTTOMRIGHT.src   = 'img/bottomRight.png'
		Images.BOTTOMLEFT.src    = 'img/bottomLeft.png'
		Images.INERSECTION.src   = 'img/intersection.png'
		Images.BLACK.src         = 'img/black.png'
		Images.WHITE.src         = 'img/white.png'
		Images.DEBUG_LIBERTY.src = 'img/debugLiberty.png'

	# draw functions ##################################################
	draw : ->
		# board color fill
		fillStyle = 'rgb(195, 142, 72)'
		@drawingContext.fillStyle = fillStyle
		@drawingContext.fillRect(0, 0, @canvas.width, @canvas.height)

		# draw individual cells
		for row in [0...@boardSize]
			for col in [0...@boardSize]
				@drawCell(@board[row][col])

		# draw the current piece with half transparency
		@drawCurrentPiece()

		# draw the cluster liberties if in DEBUG mode
		if @DEBUG
			@drawDEBUGLiberties()

		# loop the draw call
		setTimeout((=> @draw()), 1000/@FPS)

	drawCurrentPiece : ->
		if @mousePosition
			cell = @board[@mousePosition.row][@mousePosition.col]

			# do not draw current piece if there is already a piece present
			if !cell?.piece
				@drawingContext.save()
				@drawingContext.globalAlpha = @currentAlpha
				@drawImage(@turn, @mousePosition.row,
					@mousePosition.col)
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
		
		@drawImage(img, cell.row, cell.col)

		# draw the cell piece, if it has any
		if cell.piece
			@drawImage(cell.piece, cell.row, cell.col)

	drawDEBUGLiberties : () ->
		for cluster in @clusters
			for cell in cluster.cells
				for n in cell.getNeighbors()
					if !n?.piece
						@drawImage(Images.DEBUG_LIBERTY, n?.row, n?.col)

	# handler functions ###############################################
	onMouseMove : (e) =>
		# snap the x and y positions to the closest cell
		if e.offsetX
			@mousePosition =
				col : Math.floor(e.offsetX / @cellSize)
				row : Math.floor(e.offsetY / @cellSize)
		else if e.layerX
			@mousePosition =
				col : Math.floor(e.layerX / @cellSize)
				row : Math.floor(e.layerY / @cellSize)

	onMouseOut : =>
		@mousePosition = null

	onMouseClick : =>
		cell = @board[@mousePosition.row][@mousePosition.col]
		@placePiece(cell)
		console.log @clusters
		# @nextTurn()

	# game functions ##################################################
	nextTurn : ->
		@turn =
			if @turn == Images.BLACK then Images.WHITE else Images.BLACK

	placePiece : (cell) ->
		if cell and !cell.piece
			cell.piece = @turn

		@joinCluster(cell)
		@updateLiberties()

	joinCluster : (cell) ->
		for n in cell.getNeighbors()
			if n?.piece
				if n.piece == cell.piece
					# if the neighbor cell is the same type and we don't
					# already have a cluster, merge into theirs
					if !cell.cluster
						cell.setCluster(n.cluster)
					# if we are already part of a cluster and encounter a
					# different cluster as a neighbor, migrate their cluster
					# into ours
					else if n.cluster != cell.cluster
						@migrateCluster(n.cluster, cell.cluster)
		
		# if no cluster was joined, create a new one just for us
		if !cell.cluster
			cell.cluster = @createCluster(cell)

		# if this cluster is new, add it to the list of clusters on
		# the board
		if @clusters.indexOf(cell.cluster) == -1
			@clusters.push(cell.cluster)

	updateLiberties : ->
		for cluster in @clusters
			cluster.liberties = []
			for cell in cluster.cells
				for n in cell.getNeighbors()
					if !n?.piece then cluster.liberties.push(n)

	# util functions ##################################################
	drawImage : (img, row, col) ->
		@drawingContext.drawImage(img, col * @cellSize, row * @cellSize,
			@cellSize, @cellSize)

	addCellToCluster : (cell, cluster) ->
		cluster.cells.push(cell)

	migrateCluster : (from, to) ->
		for cell in from.cells
			cell.setCluster(to)
		from.cells = []
		@removeFromArray(from, @clusters)

	removeFromArray : (toRemove, array) ->
		array.splice(array.indexOf(toRemove), 1)

# DOM is ready
window.onload = -> new GoGame(true)