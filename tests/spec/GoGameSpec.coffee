describe 'A go game', ->

  beforeEach ->
    jasmine.addMatchers
      toBeEmpty: ->
        compare: (actual) ->
          pass: actual.toString().indexOf('b') == -1 and
                actual.toString().indexOf('w') == -1

      toInclude: ->
        compare: (actual, expected) ->
          pass: actual.indexOf(expected) != -1

    @game = new GoGame()

  it 'starts empty', ->
    expect @game
      .toBeEmpty()

  it 'should start with black', ->
    expect @game.turn
      .toEqual GoGame.PIECE.BLACK

  describe 'when a player places a piece not on an edge', ->

    beforeEach ->
      @cell = @game.play(2, 3)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should alternate turns', ->
      expect @game.turn
        .toEqual GoGame.PIECE.WHITE

      @game.play(0, 0)

      expect @game.turn
        .toEqual GoGame.PIECE.BLACK

    it 'should reference all 4 cells around it', ->
      expect @cell.up
        .toBe @game.board[2][2]

      expect @cell.down
        .toBe @game.board[2][4]

      expect @cell.left
        .toBe @game.board[1][3]

      expect @cell.right
        .toBe @game.board[3][3]

    it 'should reference a cluster of only itself', ->
      expect @cell.cluster.length
        .toBe 1

      expect @cell.cluster
        .toInclude(@cell)

  describe 'when a player places a piece on the top edge', ->

    beforeEach ->
      @cell = @game.play(3, 0)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 3 cells around it', ->
      expect @cell.up
        .toBe null

      expect @cell.down
        .toBe @game.board[3][1]

      expect @cell.left
        .toBe @game.board[2][0]

      expect @cell.right
        .toBe @game.board[4][0]

  describe 'when a player places a piece on the bottom edge', ->

    beforeEach ->
      @cell = @game.play(3, @game.size - 1)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 3 cells around it', ->
      expect @cell.up
        .toBe @game.board[3][@game.size - 2]

      expect @cell.down
        .toBe null

      expect @cell.left
        .toBe @game.board[2][@game.size - 1]

      expect @cell.right
        .toBe @game.board[4][@game.size - 1]

  describe 'when a player places a piece on the left edge', ->

    beforeEach ->
      @cell = @game.play(0, 3)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 3 cells around it', ->
      expect @cell.up
        .toBe @game.board[0][2]

      expect @cell.down
        .toBe @game.board[0][4]

      expect @cell.left
        .toBe null

      expect @cell.right
        .toBe @game.board[1][3]

  describe 'when a player places a piece on the right edge', ->

    beforeEach ->
      @cell = @game.play(@game.size - 1, 3)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 3 cells around it', ->
      expect @cell.up
        .toBe @game.board[@game.size - 1][2]

      expect @cell.down
        .toBe @game.board[@game.size - 1][4]

      expect @cell.left
        .toBe @game.board[@game.size - 2][3]

      expect @cell.right
        .toBe null

  describe 'when a player places a piece in the top left corner', ->

    beforeEach ->
      @cell = @game.play(0, 0)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 2 cells around it', ->
      expect @cell.up
        .toBe null

      expect @cell.down
        .toBe @game.board[0][1]

      expect @cell.left
        .toBe null

      expect @cell.right
        .toBe @game.board[1][0]

  describe 'when a player places a piece in the top right corner', ->

    beforeEach ->
      @cell = @game.play(@game.size - 1, 0)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 2 cells around it', ->
      expect @cell.up
        .toBe null

      expect @cell.down
        .toBe @game.board[@game.size - 1][1]

      expect @cell.left
        .toBe @game.board[@game.size - 2][0]

      expect @cell.right
        .toBe null

  describe 'when a player places a piece in the bottom left corner', ->

    beforeEach ->
      @cell = @game.play(0, @game.size - 1)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 2 cells around it', ->
      expect @cell.up
        .toBe @game.board[0][@game.size - 2]

      expect @cell.down
        .toBe null

      expect @cell.left
        .toBe null

      expect @cell.right
        .toBe @game.board[1][@game.size - 1]

  describe 'when a player places a piece in the bottom right corner', ->

    beforeEach ->
      @cell = @game.play(@game.size - 1, @game.size - 1)

    it 'should not be empty', ->
      expect @cell.value
        .not.toEqual GoGame.PIECE.EMPTY

    it 'should reference all 2 cells around it', ->
      expect @cell.up
        .toBe @game.board[@game.size - 1][@game.size - 2]

      expect @cell.down
        .toBe null

      expect @cell.left
        .toBe @game.board[@game.size - 2][@game.size - 1]

      expect @cell.right
        .toBe null

  describe 'when a player passes', ->

    beforeEach ->
      @originalBoard = @game.toString()
      @game.pass()

    it 'should not change the board', ->
      expect @game.toString()
        .toEqual @originalBoard

    it 'should alternate turns', ->
      expect @game.turn
        .toEqual GoGame.PIECE.WHITE

      @game.pass()

      expect @game.turn
        .toEqual GoGame.PIECE.BLACK

  describe 'when a piece is played next to another', ->
    beforeEach ->
      @black  = @game.play(0, 0)
      @white  = @game.play(0, 1)
      @black2 = @game.play(1, 0)

    it 'should share a cluster with like colors', ->
      expect @black.cluster
        .toBe @black2.cluster

      expect @black.cluster.length
        .toBe 2

      expect @black.cluster
        .toInclude(@black)

      expect @black.cluster
        .toInclude(@black2)

    it 'should not share a cluster with opposite colors', ->
      expect @black.cluster
        .not.toInclude(@white)
