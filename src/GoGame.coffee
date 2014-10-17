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
    @board[x][y].value = @turn
    @_alternateTurn()

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

  _alternateTurn: ->
    @turn = !@turn
    @

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
