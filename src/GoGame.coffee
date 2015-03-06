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

  play: (value) ->
    @value   = value
    @cluster = new Cluster(this)
    @_mergeClusters()
    return this

  surrounding: ->
    surrounding = []

    surrounding.push(@up)    if @up?
    surrounding.push(@down)  if @down?
    surrounding.push(@left)  if @left?
    surrounding.push(@right) if @right?

    return surrounding

  liberties: ->
    liberties = []

    for cell in @surrounding()
      liberties.push(cell) if cell.value == Cell.PIECE.EMPTY

    return liberties

  _mergeClusters: ->
    for cell in @surrounding()
      @cluster.merge(cell.cluster) if cell.value == @value

class Cluster

  constructor: (cell) ->
    @cells = [cell]

  liberties: ->
    liberties = []

    for cell in @cells
      liberties = liberties.concat(cell.liberties())

    return liberties

  merge: (cluster) ->
    for cell in cluster.cells
      @cells.push(cell)
      cell.cluster = this
