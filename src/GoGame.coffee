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
  Properties
  ###

  board: []
  turn:  null


  ###
  Constructor
  ###

  constructor: ->

    # create board
    for x in [0..@BOARD_SIZE]
      @board.push([])
      for y in [0..@BOARD_SIZE]
        @board[x].push(@createCell(@, x, y))

    # black starts
    @turn = @PIECE.BLACK


  ###
  Game methods
  ###

  alternateTurn: ->
    @turn = !@turn

  play: (x, y) ->
    @board[x][y].value = @turn
    @alternateTurn()

  pass: ->
    @alternateTurn()


  ###
  Util methods
  ###

  createCell: (game, x, y) ->
    game:      game
    x:         x
    y:         y
    value:     @PIECE.EMPTY

    # surrounding cell methods
    up: ->
      if @game.board[@x][@y-1]?
        return @game.board[@x][@y-1]
      null

    down: ->
      if @game.board[@x][@y+1]?
        return @game.board[@x][@y+1]
      null

    left: ->
      if @game.board[@x-1][@y]?
        return @game.board[@x-1][@y]
      null

    right: ->
      if @game.board[@x+1][@y]?
        return @game.board[@x+1][@y]
      null

  toString: ->
    string = ''
    for y in [0..@BOARD_SIZE]
      for x in [0..@BOARD_SIZE]
        string +=
          switch @board[x][y].value
            when @PIECE.EMPTY then '-'
            when @PIECE.BLACK then 'b'
            when @PIECE.WHITE then 'w'
      string += '\n'
    string
