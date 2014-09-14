class GoGame

  ###
  Properties
  ###

  BOARD_SIZE: 9
  BOARD: []
  PIECE:
    EMPTY: null
    BLACK: false
    WHITE: true


  ###
  Constructor
  ###

  constructor: ->

    # set empty board
    for y in [0..@BOARD_SIZE]
      @BOARD.push([])
      for x in [0..@BOARD_SIZE]
        @BOARD[y].push(@PIECE.EMPTY)
    console.log @toString()


  ###
  Public methods
  ###


  ###
  Private methods
  ###

  toString: ->
    string = ''
    for y in [0..@BOARD_SIZE]
      for x in [0..@BOARD_SIZE]
        string +=
          switch @BOARD[x][y]
            when @PIECE.EMPTY then '-'
            when @PIECE.BLACK then 'b'
            when @PIECE.WHITE then 'w'
      string += '\n'
    string
