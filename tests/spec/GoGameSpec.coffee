describe 'A go game', ->

  beforeEach ->
    jasmine.addMatchers
      toBeEmpty: ->
        compare: (actual) ->
          pass: actual.toString().indexOf('b') == -1 and
                actual.toString().indexOf('w') == -1

      toInclude: ->
        compare: (actual, expected) ->
          if actual instanceof Cluster
            pass: actual.cells.indexOf(expected) != -1
          else
            pass: actual.indexOf(expected) != -1


      toBeA: ->
        compare: (actual, expected) ->
          pass: actual instanceof expected

    @game = new GoGame()


  ###
  Game tests
  ###

  it 'should have a board', ->
    expect @game.board
      .toBeA Board

  it 'should start with black', ->
    expect @game.turn
      .toBe Cell.PIECE.BLACK

  it 'should alternate turns after passing', ->
    @game.pass()

    expect @game.turn
      .toBe Cell.PIECE.WHITE

    @game.pass()

    expect @game.turn
      .toBe Cell.PIECE.BLACK


  ###
  Play tests
  ###

  describe 'play', ->

    beforeEach ->
      @originalTurn = @game.turn
      @cell = @game.play(0, 0)

    it 'should return the cell played on', ->
      expect @cell
        .toBeA Cell

    it 'should set the value of the cell to the current turn', ->
      expect @cell.value
        .toBe @originalTurn

    it 'should alternate turns', ->
      expect @game.turn
        .toBe Cell.PIECE.WHITE

      @game.play(0, 1)

      expect @game.turn
        .toBe Cell.PIECE.BLACK

    it 'should have reference to a cluster that contains it', ->
      expect @cell.cluster
        .toBeA Cluster

      expect @cell.cluster
        .toInclude @cell


  ###
  Board tests
  ###

  describe 'board', ->

    beforeEach ->
      @board = @game.board

    it 'should have a size of 9', ->
      expect @board.size
        .toBe 9

    it 'should be composed of cells', ->
      expect @board.at(0, 0)
        .toBeA Cell


    ###
    Cell tesss
    ###

    describe 'cell', ->

      beforeEach ->
        @cell = @board.at(3, 2)

      it 'should start as empty', ->
        expect @cell.value
          .toBe Cell.PIECE.EMPTY

      it 'should reference the cell above it', ->
        expect @cell.up
          .toBe @board.at(3, 1)

      it 'should reference the cell below it', ->
        expect @cell.down
          .toBe @board.at(3, 3)

      it 'should reference the cell to the left of it', ->
        expect @cell.left
          .toBe @board.at(2, 2)

      it 'should reference the cell to the right of it', ->
        expect @cell.right
          .toBe @board.at(4, 2)
