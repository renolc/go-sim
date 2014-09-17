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

    # black starts
    @turn = @PIECE.BLACK

    # set empty board
    for y in [0..@BOARD_SIZE]
      @board.push([])
      for x in [0..@BOARD_SIZE]
        @board[y].push(@PIECE.EMPTY)


  ###
  Game methods
  ###

  alternateTurn: ->
    @turn = !@turn

  play: (x, y) ->
    @board[x][y] = @turn
    @alternateTurn()


  ###
  Util methods
  ###

  toString: ->
    string = ''
    for y in [0..@BOARD_SIZE]
      for x in [0..@BOARD_SIZE]
        string +=
          switch @board[x][y]
            when @PIECE.EMPTY then '-'
            when @PIECE.BLACK then 'b'
            when @PIECE.WHITE then 'w'
      string += '\n'
    string
