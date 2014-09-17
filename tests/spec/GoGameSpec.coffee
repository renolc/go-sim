describe 'A go game', ->

  beforeEach ->
    jasmine.addMatchers
      toBeEmpty: ->
        compare: (actual) ->
          expected = new GoGame()
          pass: actual.toString() == expected.toString()

      toHaveCellValueOf: ->
        compare: (actual, expected) ->
          pass: actual.board[expected.x][expected.y] == expected.value

    @game = new GoGame()

  it 'starts empty', ->
    expect @game
      .toBeEmpty()

  it 'should start with black', ->
    expect @game.turn
      .toEqual @game.PIECE.BLACK

  describe 'when a piece has been played', ->

    beforeEach ->
      @game.play(0, 0)

    it 'should not have an empty cell value', ->
      expect @game
        .not.toHaveCellValueOf
          x:     0
          y:     0
          value: @game.PIECE.EMPTY

    it 'should alternate turns', ->
      expect @game.turn
        .toEqual @game.PIECE.WHITE

      @game.play(0, 1)

      expect @game.turn
        .toEqual @game.PIECE.BLACK
