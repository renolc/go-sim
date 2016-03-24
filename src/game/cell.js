import piece from './piece'

export default (state) => {
  state.value = state.value || piece.EMPTY
  state.marked = false

  state.is = (value) => state.value === value

  state.set = (value) => state.value = value

  state.toggleMark = () => state.marked = !state.is(piece.EMPTY) && !state.marked

  return state
}
