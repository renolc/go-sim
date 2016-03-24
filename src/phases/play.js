import piece from '../game/piece'

import alternateTurns from '../helpers/alternateTurns'

export default (state) => {
  return {
    pass: () => {
      state.previousPlay = {
        turn: state.turn,
        type: 'pass'
      }
      alternateTurns(state)
    },

    play: (row, col) => {
      const initialState = state.serialize()
      const initialBoard = JSON.stringify(initialState.board)

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
      if (liberties.length === 0 || JSON.stringify(state.serialize().board) === state.previousBoard) {
        return state.load(initialState)
      }

      // if we made it here, move was valid
      state.previousBoard = initialBoard
      state.previousPlay = {
        turn: state.turn,
        type: 'play',
        position: [row, col]
      }
      alternateTurns(state)
    }
  }
}