import piece from './piece'

export default (state) => {
  state.value = state.value || piece.EMPTY

  state.is = (value) => state.value === value

  state.set = (value) => state.value = value

  return state
}
