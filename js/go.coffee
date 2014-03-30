class GoGame
	# properties ######################################################
	DEBUG             : null
	canvas            : null
	drawingContext    : null
	board             : null
	lastMousePosition : null
	mousePosition     : null
	turn              : null
	clusters          : null

	# enums and constants #############################################
	cellSize     : 20
	boardSize    : 19
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
	constructor : (elementId, debug = false) ->
		@DEBUG = debug
		
		@initCanvasAndContext(elementId)
		@initBoard()

		@loadImagesAndDraw()

	initCanvasAndContext : (elementId) ->
		@canvas = document.createElement('canvas')
		@canvas.height = @canvas.width = @cellSize * @boardSize
		@drawingContext = @canvas.getContext('2d')

		if elementId
			document.getElementById(elementId).appendChild(@canvas)
		
		# if no elementId passed in, append to the body
		else
			document.body.appendChild(@canvas)

		# setup handlers
		@addEvent(@canvas, "mousemove", @onMouseMove)
		@addEvent(@canvas, "click", @onMouseClick)
		@addEvent(@canvas, "mouseout", @onMouseOut)

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
		# draw individual cells
		for row in [0...@boardSize]
			for col in [0...@boardSize]
				@drawCell(@board[row][col])

		# draw the current piece with half transparency
		@drawCurrentPiece()

		# draw the cluster liberties if in DEBUG mode
		if @DEBUG
			@drawDEBUGLiberties()

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
		# calculate the cellSize based on the current board width (which could change
		# if the window is resized)
		cellSize = (@canvas.offsetWidth / @boardSize)
		
		@lastMousePosition = @mousePosition
		# snap the x and y positions to the closest cell
		@mousePosition =
			col : Math.floor((e.pageX - @canvas.offsetLeft) / cellSize)
			row : Math.floor((e.pageY - @canvas.offsetTop) / cellSize)
		if @lastMousePosition?.col != @mousePosition.col or @lastMousePosition?.row != @mousePosition.row
			@draw()

	onMouseOut : =>
		@mousePosition = null
		@draw()

	onMouseClick : =>
		cell = @board[@mousePosition.row][@mousePosition.col]
		@placePiece(cell)
		if @DEBUG then console.log cell.cluster.liberties
		@draw()

	# game functions ##################################################
	nextTurn : ->
		@turn =
			if @turn == Images.BLACK then Images.WHITE else Images.BLACK

	placePiece : (cell) ->
		if cell and !cell.piece
			# tentatively set the piece
			cell.piece = @turn

			# attempt to join a cluster
			success = @joinCluster(cell)

			# if we placed a piece, next turn
			if success
				@nextTurn()
			# else remove the piece since the move was invalid
			else
				cell.piece = null

	joinCluster : (cell) ->
		clustersToCheck = []
		for n in cell.getNeighbors()
			if n?.piece
				if n.piece == cell.piece
					# if the neighbor cell is the same type and we don't
					# already have a cluster, merge into theirs
					if !cell.cluster
						@addCellToCluster(cell, n.cluster)
					# if we are already part of a cluster and encounter a
					# different cluster as a neighbor, migrate their cluster
					# into ours
					else if n.cluster != cell.cluster
						@migrateCluster(n.cluster, cell.cluster)
				# if we encounter an enemy cluster, add it to the list
				# to check if it is still alive
				else
					if clustersToCheck.indexOf(n.cluster) == -1
						clustersToCheck.push(n.cluster)
		
		# if no cluster was joined, create a new one just for us
		if !cell.cluster
			cell.cluster = @createCluster(cell)

		# if this cluster is new, add it to the list of clusters on
		# the board
		if @clusters.indexOf(cell.cluster) == -1
			@clusters.push(cell.cluster)

		@updateLiberties(clustersToCheck, cell.cluster)

	updateLiberties : (clusters, currentCluster) ->
		for cluster in clusters
			if cluster
				cluster.liberties = []
				for cell in cluster.cells
					for n in cell.getNeighbors()
						if n and !n.piece then cluster.liberties.push(n)
				if cluster.liberties.length == 0
					@removeCluster(cluster)

		# always check our own cluster last to make sure our move
		# was valid
		currentCluster.liberties = []
		for cell in currentCluster.cells
			for n in cell.getNeighbors()
				if n and !n.piece then currentCluster.liberties.push(n)
		if currentCluster.liberties.length == 0
			return false

		return true

	# util functions ##################################################
	drawImage : (img, row, col) ->
		@drawingContext.drawImage(img, col * @cellSize, row * @cellSize,
			@cellSize, @cellSize)

	addCellToCluster : (cell, cluster) ->
		cell.cluster = cluster
		cluster.cells.push(cell)

	migrateCluster : (from, to) ->
		for cell in from.cells
			@addCellToCluster(cell, to)
		from.cells = []
		@removeFromArray(from, @clusters)

	removeFromArray : (toRemove, array) ->
		array.splice(array.indexOf(toRemove), 1)

	removeCluster : (cluster) ->
		for cell in cluster.cells
			cell.piece = null
		@removeFromArray(cluster, @clusters)

	addEvent : (element, event, handler) ->
		if element.addEventListener
			element.addEventListener(event, handler, false)
		else if element.attachEvent
			element.attachEvent('on' + event, handler)
		else
			element['on' + event] = handler