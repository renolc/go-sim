class GoGame

  ###
  Constants
  ###

  @PIECE:
    EMPTY: null
    BLACK: false
    WHITE: true


  ###
  Constructor
  ###

  constructor: (size = 9) ->

    # properties
    @size  = size
    @board = []
    @turn  = null

    # create board
    for y in [0...@size]
      for x in [0...@size]
        @_createCell(x, y)

    # black starts
    @turn = GoGame.PIECE.BLACK


  ###
  Game methods
  ###

  play: (x, y) ->

    cell = @board[x][y]
    cell.value = @turn

    @_mergeClusters(cell)

    @_alternateTurn()

    cell

  pass: ->
    @_alternateTurn()


  ###
  Util methods
  ###

  _createCell: (x, y) ->

    # build board row for this cell if needed
    if !@board[x]?
      @board[x] = []

    # create new cell
    cell = @_cellTemplate()

    # add cell to its own cluster
    cell.cluster.push(cell)

    # place new cell in board
    @board[x][y] = cell

    # connect all surrounding cell references
    if y - 1 >= 0
      up = @board[x][y - 1]
      if up?
        cell.up = up
        up.down = cell

    if y + 1 < @size

      # build next board column if needed
      if !@board[x][y + 1]?
        @board[x][y + 1] = []

      down = @board[x][y + 1]
      if down?
        cell.down = down
        down.up = cell

    if x - 1 >= 0
      left = @board[x - 1][y]
      if left?
        cell.left = left
        left.right = cell

    if x + 1 < @size

      # build next board row if needed
      if !@board[x + 1]?
        @board[x + 1] = []

      right = @board[x + 1][y]
      if right?
        cell.right = right
        right.left = cell

    cell

  _cellTemplate: ->
    value: GoGame.PIECE.EMPTY

    # surrounding cell references
    up:    null
    down:  null
    left:  null
    right: null

    # cluster of related cells
    cluster: []

  _alternateTurn: ->
    @turn = !@turn

  _getSurrounding: (cell) ->
    surrounding = []

    if cell.up?.value == cell.value
      surrounding.push(cell.up)

    if cell.down?.value == cell.value
      surrounding.push(cell.down)

    if cell.left?.value == cell.value
      surrounding.push(cell.left)

    if cell.right?.value == cell.value
      surrounding.push(cell.right)

    surrounding

  _mergeClusters: (cell) ->
    for c in @_getSurrounding(cell)
      if c.cluster != cell.cluster
        c.cluster = cell.cluster
        c.cluster.push(c)
        @_mergeClusters(c)

  toString: ->
    string = ''
    for y in [0...@size]
      for x in [0...@size]
        string +=
          switch @board[x][y].value
            when GoGame.PIECE.EMPTY then '-'
            when GoGame.PIECE.BLACK then 'b'
            when GoGame.PIECE.WHITE then 'w'
      string += '\n'
    string
