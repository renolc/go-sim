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
    }
  }
}