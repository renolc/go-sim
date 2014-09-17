describe 'A go game', ->

  beforeEach ->
    jasmine.addMatchers
      toBeEmpty: ->
        compare: (actual) ->
          pass: actual.toString().indexOf('b') == -1 and
                actual.toString().indexOf('w') == -1

    @game = new GoGame()

  it 'starts empty', ->
    expect @game
      .toBeEmpty()

  it 'should start with black', ->
    expect @game.turn
      .toEqual @game.PIECE.BLACK

  describe 'when a player places a piece not on an edge', ->

    beforeEach ->
      @game.play(2, 3)

    it 'should have an cell value of black', ->
      expect @game.board[2][3].value
        .toEqual @game.PIECE.BLACK

    it 'should alternate turns', ->
      expect @game.turn
        .toEqual @game.PIECE.WHITE

      @game.play(0, 0)

      expect @game.turn
        .toEqual @game.PIECE.BLACK

  describe 'when a player passes', ->
    originalBoard = null

    beforeEach ->
      originalBoard = @game.toString()
      @game.pass()

    it 'should not change the board', ->
      expect @game.toString()
        .toEqual originalBoard

    it 'should alternate turns', ->
      expect @game.turn
        .toEqual @game.PIECE.WHITE

      @game.pass()

      expect @game.turn
        .toEqual @game.PIECE.BLACK
