import removePhase from './removePhase'
import addPhase from './addPhase'

export default (state, phase) => {
  removePhase(state)
  state.phase = phase
  addPhase(state)
}