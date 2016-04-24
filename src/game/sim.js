import phase from './phase'
import piece from './piece'
import board from './board'

import addPhase from '../helpers/addPhase'
import changePhase from '../helpers/changePhase'

export default (...args) => {
  var size = 9
  var state

  const arg = args[0]

  switch (typeof arg) {

    // load game state
    case 'object':
      state = {...arg}
      state.board = board(state.board)
      break

    // set board size and fall through into default
    case 'number':
      size = arg

    // everything else
    default: // eslint-disable-line
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
    const originalPhase = state.phase
    Object.keys(load).forEach((key) => {
      state[key] = load[key]
    })
    state.board = board(state.board)

    // hack to ensure loaded phase methods are available
    const newPhase = state.phase
    state.phase = originalPhase
    changePhase(state, newPhase)
  }

  // initialize current phase
  addPhase(state)

  return state
}
