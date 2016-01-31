import { piece } from './cell'
import board from './board'

import stateProps from './helpers/state-props'

export default ({ size = 9, load = {} } = {}) => {
  const loadState = (Object.keys(load).length === 0)
    ? {}
    : JSON.parse(load)

  const { state, obj } = stateProps({
    board: (loadState.board)
      ? board({ load: loadState.board })
      : board({ size: size }),
    turn: loadState.turn || piece.BLACK
  })

  obj.serialize = () => {
    return JSON.stringify({
      turn: state.turn,
      board: state.board.serialize()
    })
  }

  obj.pass = () => {
    alternateTurns(state)
  }

  obj.play = (row, col) => {
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

    // if no liberties where we played, invalid move
    const { liberties } = state.board.clusterAt(cell.row, cell.col)
    if (liberties.length === 0) {
      cell.set(piece.EMPTY)
      return
    }

    alternateTurns(state)
  }

  return obj
}

function alternateTurns (state) {
  state.turn = (state.turn === piece.BLACK)
    ? piece.WHITE
    : piece.BLACK
}
