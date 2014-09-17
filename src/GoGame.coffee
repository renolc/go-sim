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
    for y in [0..@BOARD_SIZE]
      @board.push([])
      for x in [0..@BOARD_SIZE]
        @board[y].push(@createCell(x, y))

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

  createCell: (x, y) ->
    x:     x
    y:     y
    value: @PIECE.EMPTY

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
