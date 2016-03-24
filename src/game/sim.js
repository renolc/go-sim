import phase from './phase'
import piece from './piece'
import board from './board'

import addPhase from '../helpers/addPhase'

export default (...args) => {
  var size = 9
  var state

  const arg = args[0]

  switch(typeof arg) {

    // load game state
    case 'object':
      state = {...arg}
      state.board = board(state.board)
      break

    // set board size and fall through into default
    case 'number':
      size = arg

    // everything else
    default:
      state = {
        board: board(size),
        turn: piece.BLACK,
        previousBoard: null,
        phase: phase.PLAY,
        previousPlay: {}
      }
  }

  // serialize state into vanilla js object (functions pruned)
  state.serialize = () => JSON.parse(JSON.stringify(state))

  // load a different state into the current instance
  state.load = (load) => {
    Object.keys(load).forEach((key) => {
      state[key] = load[key]
      state.board = board(state.board)
    })
  }

  addPhase(state)

  return state
}