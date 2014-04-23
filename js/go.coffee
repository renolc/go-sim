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
	
	# the size in pixels of each cell (width and height)
	CELL_SIZE     : 20

	# the number of cells the board should be (width and height)
	BOARD_SIZE    : 19

	# the alpha level the hover piece should be
	CURRENT_ALPHA : 0.5

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
	
	# create and start the game
	#
	# elementId  ID of an element to append the board canvas to
	# debug      if the game is in debug mode
	constructor : (elementId, debug = false) ->
		@DEBUG = debug
		
		@initCanvasAndContext(elementId)
		@initBoard()

		@loadImagesAndDraw()

	# create the HTML5 canvas and cache the drawing context
	#
	# elementId  ID of an element to append the board canvas to
	initCanvasAndContext : (elementId) ->
		@canvas = document.createElement('canvas')
		@canvas.height = @canvas.width = @CELL_SIZE * @BOARD_SIZE
		@drawingContext = @canvas.getContext('2d')
		elementFound = false

		#if an element ID was passed in
		# and the element was found, append the canvas to it
		if elementId 
			element = document.getElementById(elementId)
			if element
				elementFound = true
				element.innerHTML = ''
				element.appendChild(@canvas)
		
		# if no element was found, append to the body
		if not elementFound
			document.body.appendChild(@canvas)

		# setup handlers
		@addEvent(@canvas, "mousemove", @onMouseMove)
		@addEvent(@canvas, "click", @onMouseClick)
		@addEvent(@canvas, "mouseout", @onMouseOut)

	# initialize the board structure
	initBoard : ->
		# black goes first
		@turn = Images.BLACK

		@clusters = []
		@board = []

		for row in [0...@BOARD_SIZE]
			@board[row] = []

			for col in [0...@BOARD_SIZE]
				@board[row][col] = @createCell(row, col)

	# create a cell object
	#
	# row  a row of the board
	# col  a column of the board
	createCell : (row, col) ->
		piece   : null
		cluster : null
		row     : row
		col     : col

		# get the neighbor cells around this one
		getNeighbors : =>
			cell = @board[row][col]
			neighbors = []
			for k, v of Position
				neighbors.push(cell.getNeighbor(v))
			neighbors

		# get a specific neighbor cell
		#
		# position  the relative position to check
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

	# create a cluster object
	#
	# cell  an initial cell to add to this cluster
	createCluster : (cell) ->
		cells     : [cell]
		liberties : []

	# load all the images used to render the game
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
		for row in [0...@BOARD_SIZE]
			for col in [0...@BOARD_SIZE]
				@drawCell(@board[row][col])

		# draw the current piece with half transparency
		@drawCurrentPiece()

		# draw the cluster liberties if in DEBUG mode
		if @DEBUG
			@drawDEBUGLiberties()

	# draw a piece at half transparency where the mouse is located
	drawCurrentPiece : ->
		if @mousePosition
			cell = @board[@mousePosition.row][@mousePosition.col]

			# do not draw current piece if there is already a piece present
			if !cell?.piece
				@drawingContext.save()
				@drawingContext.globalAlpha = @CURRENT_ALPHA
				@drawImage(@turn, @mousePosition.row,
					@mousePosition.col)
				@drawingContext.restore()

	# draw a specific cell, including its background
	# and piece (if it has one)
	#
	# cell  the cell to draw
	drawCell : (cell) ->
		# draw the correct intersection
		if cell.row == 0 and cell.col == 0
			img = Images.TOPLEFT
		else if cell.row == 0 and cell.col == @BOARD_SIZE - 1
			img = Images.TOPRIGHT
		else if cell.row == @BOARD_SIZE - 1 and cell.col == 0
			img = Images.BOTTOMLEFT
		else if cell.row == @BOARD_SIZE - 1 and cell.col == @BOARD_SIZE - 1
			img = Images.BOTTOMRIGHT
		else if cell.row == 0
			img = Images.TOP
		else if cell.row == @BOARD_SIZE - 1
			img = Images.BOTTOM
		else if cell.col == 0
			img = Images.LEFT
		else if cell.col == @BOARD_SIZE - 1
			img = Images.RIGHT
		else
			img = Images.INERSECTION
		
		@drawImage(img, cell.row, cell.col)

		# draw the cell piece, if it has any
		if cell.piece
			@drawImage(cell.piece, cell.row, cell.col)

	# draw the liberties for every cluster on the board
	drawDEBUGLiberties : () ->
		for cluster in @clusters
			for cell in cluster.cells
				for n in cell.getNeighbors()
					if !n?.piece
						@drawImage(Images.DEBUG_LIBERTY, n?.row, n?.col)

	# handler functions ###############################################

	# when the mouse moves, get the cell under the mouse
	# and if necessary redraw the board
	#
	# e  the mouse event
	onMouseMove : (e) =>
		# calculate the CELL_SIZE based on the current board width (which could change
		# if the window is resized)
		cellWidth = (@canvas.offsetWidth / @BOARD_SIZE)
		cellHeight = (@canvas.offsetHeight / @BOARD_SIZE)
		
		@lastMousePosition = @mousePosition
		# snap the x and y positions to the closest cell
		@mousePosition =
			col : Math.floor((e.pageX - @canvas.offsetLeft) / cellWidth)
			row : Math.floor((e.pageY - @canvas.offsetTop) / cellHeight)

		# if the mouse has moved to a new cell, redraw the board
		if @lastMousePosition?.col != @mousePosition.col or @lastMousePosition?.row != @mousePosition.row
			@draw()

	# when the mouse leaves the canvas, clear out the mouse position
	# and redraw the board
	onMouseOut : =>
		@mousePosition = null
		@draw()

	# when the mouse is clicked, attempt to place a piece there
	# and if in debug mode, log out all of the liberties for the
	# resulting cluster
	# finally, redraw the board
	onMouseClick : =>
		cell = @board[@mousePosition.row][@mousePosition.col]
		@placePiece(cell)
		if @DEBUG then console.log cell.cluster.liberties
		@draw()

	# game functions ##################################################
	
	# advance the turn to the next piece
	nextTurn : ->
		@turn =
			if @turn == Images.BLACK then Images.WHITE else Images.BLACK

	# attempt to place a piece in a cell
	#
	# cell  the cell to place a piece into
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

	# add a cell to a cluster
	#
	# cell  the cell to check around and add to a cluster
	joinCluster : (cell) ->

		# these will be enemy clusters to check if we killed
		clustersToCheck = []

		# loop through all neighbor cells
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

		# update all the liberties in the affected clusters
		@updateLiberties(clustersToCheck, cell.cluster)

	# check all the clusters passed in and update their liberties list
	# next check if the current cluster has any liberties remaining
	# if not, the move was invalid
	#
	# clusters        the enemy clusters to check if are still alive
	# currentCluster  the cluster just placed to check if move was valid
	updateLiberties : (clusters, currentCluster) ->
		
		# loop through all the clusters passed in
		for cluster in clusters
			if cluster

				# clear out the cluster's liberties
				cluster.liberties = []

				# loop through all cells in a cluster
				for cell in cluster.cells

					# get the neighbors of this cell
					for n in cell.getNeighbors()

						# if the neighbor cell is empty, add the cell to the list
						# of liberties for the cluster
						if n and !n.piece then cluster.liberties.push(n)
				
				# if, after checking all the cells, the cluster has no liberties
				# then it was killed, so remove the cluster
				if cluster.liberties.length == 0
					@removeCluster(cluster)

		# always check our own cluster last to make sure our move
		# was valid
		currentCluster.liberties = []
		for cell in currentCluster.cells
			for n in cell.getNeighbors()
				if n and !n.piece then currentCluster.liberties.push(n)
		
		# if the current cluster has no liberties remaining
		# then the move would kill the current cluster which is invalid
		# so return false which will undo the move
		if currentCluster.liberties.length == 0
			return false

		# the move was valid
		return true

	# util functions ##################################################
	
	# a proxy function that simplifies the draw command
	#
	# img  the image to draw
	# row  the row of the board to draw to
	# col  the column of the board to draw to
	drawImage : (img, row, col) ->
		@drawingContext.drawImage(img, col * @CELL_SIZE, row * @CELL_SIZE,
			@CELL_SIZE, @CELL_SIZE)

	# add a cell to a cluster
	#
	# cell     the cell to add to the cluster
	# cluster  the cluster to add the cell to
	addCellToCluster : (cell, cluster) ->
		cell.cluster = cluster
		cluster.cells.push(cell)

	# migrate all the cells from one cluster to another
	# then remove the empty cluster from clusters list
	#
	# from  the cluster to migrate from
	# to    the cluster to migrate to
	migrateCluster : (from, to) ->
		for cell in from.cells
			@addCellToCluster(cell, to)
		from.cells = []
		@removeFromArray(from, @clusters)

	# proxy function to remove an element from an array
	#
	# toRemove  the item to remove
	# array     the array to remove from
	removeFromArray : (toRemove, array) ->
		array.splice(array.indexOf(toRemove), 1)

	# remove a cluster from the game by first clearing
	# all of the associated pieces, and then removing the cluster
	# from the clusters list
	#
	# cluster  the cluster to remove from the game
	removeCluster : (cluster) ->
		for cell in cluster.cells
			cell.piece = null
		@removeFromArray(cluster, @clusters)

	# proxy function to add an event regardless of what
	# browser we are in
	#
	# element  the element to add an event to
	# event    the event to add
	# handler  the handler function for the event
	addEvent : (element, event, handler) ->
		if element.addEventListener
			element.addEventListener(event, handler, false)
		else if element.attachEvent
			element.attachEvent('on' + event, handler)
		else
			element['on' + event] = handler