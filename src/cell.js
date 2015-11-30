export const piece = Object.freeze({
  EMPTY: 'empty',
  BLACK: 'black',
  WHITE: 'white'
})

export default (row, col) => {
  const state = {
    row,
    col,
    value: piece.EMPTY
  }

  return {
    state,

    is(value) {
      return state.value === value
    }
  }
}