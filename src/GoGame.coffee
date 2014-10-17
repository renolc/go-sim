class GoGame

  ###
  Constants
  ###

  BOARD_SIZE: 9
  PIECE:
    EMPTY: null
    BLACK: false
    WHITE: true


  ###
  Constructor
  ###

  constructor: ->

    # properties
    @board = []
    @turn = null

    # create board
    for x in [0...@BOARD_SIZE]
      @board.push([])
      for y in [0...@BOARD_SIZE]
        @board[x].push(@_createCell(@, x, y))

    # black starts
    @turn = @PIECE.BLACK


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

  _createCell: (game, x, y) ->
    game:      game
    x:         x
    y:         y
    value:     game.PIECE.EMPTY

    # caching properties
    _up:          null
    _down:        null
    _left:        null
    _right:       null
    _surrounding: null

    # surrounding cell methods
    surroundingCells: ->
      if @_surrounding == null
        @_surrounding = []
        if @up()?
          @_surrounding.push(@up())
        if @down()?
          @_surrounding.push(@down())
        if @left()?
          @_surrounding.push(@left())
        if @right()?
          @_surrounding.push(@right())
      @_surrounding

    up: ->
      if @_up == null and @y - 1 >= 0
        @_up = @game.board[@x][@y - 1]
      @_up

    down: ->
      if @_down == null and @y + 1 < @game.BOARD_SIZE
        @_down = @game.board[@x][@y + 1]
      @_down

    left: ->
      if @_left == null and @x - 1 >= 0
        @_left = @game.board[@x - 1][@y]
      @_left

    right: ->
      if @_right == null and @x + 1 < @game.BOARD_SIZE
        @_right = @game.board[@x + 1][@y]
      @_right

  _alternateTurn: ->
    @turn = !@turn
    @

  toString: ->
    string = ''
    for y in [0...@BOARD_SIZE]
      for x in [0...@BOARD_SIZE]
        string +=
          switch @board[x][y].value
            when @PIECE.EMPTY then '-'
            when @PIECE.BLACK then 'b'
            when @PIECE.WHITE then 'w'
      string += '\n'
    string
