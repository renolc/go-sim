import { piece } from './cell'
import board from './board'

export default (size = 9) => {
  const state = {
    board: board(size),
    turn: piece.BLACK
  }

  return {
    state,

    toString() {
      return JSON.stringify(state)
    },

    pass() {
      state.turn = (state.turn === piece.BLACK)
        ? piece.WHITE
        : piece.BLACK
    },

    play(row, col) {
      const cell = state.board.at(row, col)
      if (!cell || !cell.is(piece.EMPTY)) return

      cell.set(state.turn)

      this.pass()
    }
  }
}