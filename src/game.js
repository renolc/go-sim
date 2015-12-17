import { piece } from './cell'
import board from './board'

import stateProps from './helpers/state-props'

export default (size = 9) => {
  const { state, obj } = stateProps({
    board: board(size),
    turn: piece.BLACK
  })

  obj.serialize = () => {
    return JSON.stringify({
      turn: state.turn,
      board: state.board.serialize()
    })
  }

  obj.pass = () => {
    state.turn = (state.turn === piece.BLACK)
      ? piece.WHITE
      : piece.BLACK
  }

  obj.play = (row, col) => {
    const cell = state.board.at(row, col)
    if (!cell || !cell.is(piece.EMPTY)) return

    cell.set(state.turn)

    obj.pass()
  }

  return obj
}