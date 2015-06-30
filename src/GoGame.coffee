class GoGame

  constructor: (size = 19) ->
    @board = new Board(size)
    @turn  = Cell.PIECE.BLACK

  pass: ->
    @alternateTurn()

  play: (x, y) ->
    cell = @board.at(x, y)?.play(@turn)
    @alternateTurn() if cell
    return cell

  alternateTurn: ->
    @turn = !@turn


class Board

  constructor: (size) ->
    @size  = size
    @cells = []

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
    return @cells[x]?[y]


class Cell

  @PIECE:
    EMPTY: null
    BLACK: false
    WHITE: true

  constructor: ->
    @value = Cell.PIECE.EMPTY

  play: (value) ->

    # if cell not empty, reject move
    return false if not this.is(Cell.PIECE.EMPTY)

    @value = value

    # if any surrounding enemy clusters have no remaining liberties, remove them
    for cell in @surrounding()
      if cell.is(!@value) and cell.cluster.liberties().length == 0
        cell.cluster.remove()

    # check for surrounding friendly clusters
    thisCellLibertiesCount = @liberties().length
    surroundingFriendlyClusters = 0
    surroundingFriendlyClustersWithNoLiberties = 0
    for cell in @surrounding()
      if cell.is(@value)
        surroundingFriendlyClusters++
        if cell.cluster.liberties().length + thisCellLibertiesCount == 0
          surroundingFriendlyClustersWithNoLiberties++

    # if all of the surrounding friendly clusters no have no liberties, invalid
    if surroundingFriendlyClusters > 0 and surroundingFriendlyClusters == surroundingFriendlyClustersWithNoLiberties
      @value = Cell.PIECE.EMPTY
      return false

    # if no surrounding friendly clusters to join, and this cell has no liberties, invalid
    if surroundingFriendlyClusters == 0 and thisCellLibertiesCount == 0
      @value = Cell.PIECE.EMPTY
      return false

    # merge with any neighboring friendly clusters
    @cluster = new Cluster(this)
    @mergeClusters()

    return this

  remove: ->
    @value = Cell.PIECE.EMPTY
    @cluster = null

  is: (value) ->
    @value == value

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
      liberties.push(cell) if cell.is(Cell.PIECE.EMPTY) and cell not in liberties

    return liberties

  mergeClusters: ->
    for cell in @surrounding()
      @cluster.merge(cell.cluster) if cell.is(@value)

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
      @cells.push(cell) if cell not in @cells
      cell.cluster = this

  remove: ->
    for cell in @cells
      cell.remove()

    @cells = []
