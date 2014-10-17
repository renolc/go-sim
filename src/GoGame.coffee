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
    @boardSize = size
    @board     = []
    @turn      = null

    # create board
    for x in [0...@boardSize]
      @board.push([])
      for y in [0...@boardSize]
        @board[x].push(@_createCell(x, y))

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
    self:  @
    x:     x
    y:     y
    value: GoGame.PIECE.EMPTY

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
        @_up = @self.board[@x][@y - 1]
      @_up

    down: ->
      if @_down == null and @y + 1 < @self.boardSize
        @_down = @self.board[@x][@y + 1]
      @_down

    left: ->
      if @_left == null and @x - 1 >= 0
        @_left = @self.board[@x - 1][@y]
      @_left

    right: ->
      if @_right == null and @x + 1 < @self.boardSize
        @_right = @self.board[@x + 1][@y]
      @_right

  _alternateTurn: ->
    @turn = !@turn
    @

  toString: ->
    string = ''
    for y in [0...@boardSize]
      for x in [0...@boardSize]
        string +=
          switch @board[x][y].value
            when GoGame.PIECE.EMPTY then '-'
            when GoGame.PIECE.BLACK then 'b'
            when GoGame.PIECE.WHITE then 'w'
      string += '\n'
    string
