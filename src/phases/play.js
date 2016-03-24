import alternateTurns from '../helpers/alternateTurns'

export default (state) => {
  return {
    pass: () => {
      alternateTurns(state)
    },

    play: (row, col) => {
      const initialState = obj.serialize()
      const initialBoard = JSON.stringify(obj.board.serialize())

      const cell = state.board.at(row, col)
      if (!cell || !cell.is(piece.EMPTY)) return

      cell.set(state.turn)

      // remove captured clusters
      state.board.neighborCells(row, col)
        .filter((c) => {
          return c.is(
              (state.turn === piece.BLACK)
                ? piece.WHITE
                : piece.BLACK
            )
        })
        .forEach((cell) => {
          const { cluster, liberties } = state.board.clusterAt(cell.row, cell.col)
          if (liberties.length === 0) {
            cluster.forEach((cell) => {
              cell.set(piece.EMPTY)
            })
          }
        })

      // if no liberties where we played or new board looks like previous board, invalid move
      const { liberties } = state.board.clusterAt(cell.row, cell.col)
      if (liberties.length === 0 || JSON.stringify(obj.board.serialize()) === obj.previousBoard) {
        return obj.load(initialState)
      }

      // if we made it here, move was valid
      obj.previousBoard = initialBoard
      obj.previousPlay = {
        turn: state.turn,
        type: 'play',
        position: [row, col]
      }
      alternateTurns(state)
    }
  }
}