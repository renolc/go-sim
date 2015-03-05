class GoGame

  constructor: (size = 9) ->
    @board = new Board(size)
    @turn  = Cell.PIECE.BLACK

  pass: ->
    @_alternateTurn()

  play: (x, y) ->
    cell = @board.at(x, y).play(@turn)
    @_alternateTurn()
    return cell

  _alternateTurn: ->
    @turn = !@turn


class Board

  constructor: (size) ->
    @size     = size
    @cells    = []
    @clusters = []

    for x in [0...@size]
      @cells.push([])
      for y in [0...@size]
        cell = new Cell()
        @cells[x].push(cell)

        if y > 0
          up = @cells[x][y-1]
          cell.up = up
          up.down = cell

        if x > 0
          left = @cells[x-1][y]
          cell.left  = left
          left.right = cell

  at: (x, y) ->
    return @cells[x][y]


class Cell

  @PIECE:
    EMPTY: null
    BLACK: false
    WHITE: true

  constructor: ->
    @value = Cell.PIECE.EMPTY

    @up = @down = @left = @right = null

  play: (value) ->
    @value = value
    return this


class Cluster

  constructor: (cell) ->
    @cells = [cell]

  add: (cell) ->
    @cells.push(cell)
