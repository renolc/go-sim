import alternateTurns from '../helpers/alternateTurns'
import changePhase from '../helpers/changePhase'

import phase from '../game/phase'
import piece from '../game/piece'

export default (state) => {
  return {
    mark: (row, col) => {
      const { cells } = state.board.clusterAt(row, col)

      cells.forEach((cell) => cell.toggleMark())
    },

    propose: () => alternateTurns(state),

    accept: () => {
      state.board.cells
        .forEach((cell) => {
          if (cell.marked) cell.set(piece.EMPTY)
        })
      changePhase(state, phase.END)
    },

    reject: () => {
      state.board.cells
        .forEach((cell) => {
          if (cell.marked) cell.toggleMark()
        })
      changePhase(state, phase.PLAY)
    }
  }
}